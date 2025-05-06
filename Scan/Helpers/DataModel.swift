//
//  DataModel.swift
//  Look Left Look Right
//
//  Created by Sean on 6/5/25.
//


/*
 See the License.txt file for this sample’s licensing information.
 */

import AVFoundation
import SwiftUI
import Vision
import os.log

final class DataModel: ObservableObject {
    let camera = Camera()
    @Published var takenImage: Image?
    @Published var viewfinderImage: Image?
    
    var isPhotosLoaded = false
    
    var visionTask: Task<Void, Never>? = nil
    init() {
        Task {
            await handleCameraPreviews()
        }
        
        Task {
            await handleCameraPhotos()
        }
    }
    
    func handleCameraPreviews() async {
        var ciImage: CIImage?
        let imageStream = camera.previewStream
            .map { ciImage = $0; return $0.image }
        
        
        for await image in imageStream {
            Task { @MainActor in
                if let ciImage {
                    detectFace(in: ciImage)
                }
                viewfinderImage = image
            }
        }
    }
    
    func handleCameraPhotos() async {
        let unpackedPhotoStream = camera.photoStream
            .compactMap { self.unpackPhoto($0) }
        
        for await photoData in unpackedPhotoStream {
            savePhoto(image: photoData.cgImage)
            
        }
    }
    
    private func unpackPhoto(_ photo: AVCapturePhoto) -> PhotoData? {
        guard let imageData = photo.fileDataRepresentation() else { return nil }
        guard let image = photo.cgImageRepresentation() else { return nil }
        guard let previewCGImage = photo.previewCGImageRepresentation(),
              let metadataOrientation = photo.metadata[String(kCGImagePropertyOrientation)] as? UInt32,
              let cgImageOrientation = CGImagePropertyOrientation(rawValue: metadataOrientation) else { return nil }
        let imageOrientation = Image.Orientation(cgImageOrientation)
        
        let photoDimensions = photo.resolvedSettings.photoDimensions
        let imageSize = (width: Int(photoDimensions.width), height: Int(photoDimensions.height))
        let previewDimensions = photo.resolvedSettings.previewDimensions
        
        return PhotoData(cgImage: image, imageData: imageData, imageSize: imageSize)
    }
    
    func savePhoto(image: CGImage) {
        Task {
            // do face detection stuff here instead of saving?
            takenImage = Image(uiImage: UIImage(cgImage: image))
            logger.debug("Added image data to photo collection.")
            
        }
    }
    
    func detectFace(in image: CIImage) {
        // dont do anything if vision task running

        guard visionTask == nil || visionTask?.isCancelled == true else { return }
        
        visionTask = Task(priority: .userInitiated) {
            let request = DetectFaceLandmarksRequest()
            do {
                let points = try await request.perform(on: image).map { observation in
                    print("Face detected \(observation.description)")
                    
                    return observation
                }
                
                
                // cancel task if nothing detected after 1s
                try await Task.sleep(for: .seconds(1))
                visionTask!.cancel()
            } catch {
                print("Error in face detection: \(error.localizedDescription)")
            }
        }
    }
    
    func cropFace(of image: CGImage, with face: [CGPoint]) {
        // need bounding region and then my
    }
    
}

fileprivate struct PhotoData {
    var cgImage: CGImage
    var imageData: Data
    var imageSize: (width: Int, height: Int)
}

fileprivate extension CIImage {
    var image: Image? {
        let ciContext = CIContext()
        guard let cgImage = ciContext.createCGImage(self, from: self.extent) else { return nil }
        return Image(decorative: cgImage, scale: 1, orientation: .up)
    }
}

fileprivate extension Image.Orientation {
    
    init(_ cgImageOrientation: CGImagePropertyOrientation) {
        switch cgImageOrientation {
        case .up: self = .up
        case .upMirrored: self = .upMirrored
        case .down: self = .down
        case .downMirrored: self = .downMirrored
        case .left: self = .left
        case .leftMirrored: self = .leftMirrored
        case .right: self = .right
        case .rightMirrored: self = .rightMirrored
        }
    }
}

fileprivate let logger = Logger(subsystem: "com.apple.swiftplaygroundscontent.capturingphotos", category: "DataModel")
