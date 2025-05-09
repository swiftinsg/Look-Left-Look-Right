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
import UIKit
import SwiftUI
import Vision
import os.log

@Observable
final class DataModel {
    let camera = Camera()
    var takenImage: Image?
    var viewfinderImage: Image?
    var faceBoxes: [CGRect] = []
    var displayImageSize: CGSize = .zero
    var safeAreaOffset: CGFloat = .zero
    var cropping: Bool = false
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
                if takenImage == nil {
                    viewfinderImage = image
                }
            }
        }
    }
    
    func handleCameraPhotos() async {
        let unpackedPhotoStream = camera.photoStream
            .compactMap { self.unpackPhoto($0) }
        
        for await photoData in unpackedPhotoStream {
            await MainActor.run {
                withAnimation {
                    cropping = true
                }
            }
            detectFaceAndCrop(in: photoData.cgImage)
        }
    }
    
    private func unpackPhoto(_ photo: AVCapturePhoto) -> PhotoData? {
        guard let imageData = photo.fileDataRepresentation() else { return nil }
        guard let image = photo.cgImageRepresentation() else { return nil }
        
        let photoDimensions = photo.resolvedSettings.photoDimensions
        let imageSize = (width: Int(photoDimensions.width), height: Int(photoDimensions.height))
        return PhotoData(cgImage: image, imageData: imageData, imageSize: imageSize)
    }
    
    func savePhoto(image: CGImage) {
        Task {
            // do face detection stuff here instead of saving?
            await MainActor.run {
                takenImage = Image(uiImage: UIImage(cgImage: image))
            }
            logger.debug("Added image data to photo collection.")
            
        }
    }
    
    func detectFaceAndCrop(in cgImage: CGImage) {
        // Take over vision task if not
        if let task = visionTask {
            if !task.isCancelled {
                task.cancel()
            }
        }
        
        guard (visionTask == nil || visionTask?.isCancelled == true) else { return }
        
        visionTask = Task(priority: .userInitiated) {
            let request = DetectFaceLandmarksRequest()
            do {
                let points = try await request.perform(on: cgImage).map { observation in
                    return observation
                }
                
                if let firstFace = points.first, let landmarks = firstFace.landmarks {
                    let bounds = CGRect(x: 0, y:0, width: cgImage.width, height: cgImage.height)
                    let allPoints = landmarks.allPoints.pointsInImageCoordinates(CGSize(width: bounds.width, height: bounds.height))
                    let boundingPath = CGMutablePath()
                    // reverse the new points so that the two same points (rightmost ending) are at the same position
                    // add the first point of the initial set of points to close the loop
                    
//                    allPoints.append(contentsOf: newPoints)
 
                    // finally, add the new set of points to all points array
                    boundingPath.addLines(between: allPoints)
                    let originalRect = boundingPath.boundingBox
                    let increasedX = CGFloat(originalRect.minX * 0.8)
                    let newRect = CGRect(x: increasedX, y: originalRect.minY, width: CGFloat(originalRect.width * 1.2), height: CGFloat(originalRect.height))
//                    let altPath = CGMutablePath()
//                    let transform = CGAffineTransform(translationX: -bounds.midX, y: -bounds.midY).concatenating(.init(scaleX: -1, y: -1).concatenating(CGAffineTransform.init(translationX: bounds.midX, y: bounds.midY)))
//                    boundingPath.addLines(between: allPoints, transform: transform)
                    
                    let finalPath = CGPath(ellipseIn: newRect, transform: nil)
                    
                    
                    let croppedFace = await cropFace(of: cgImage, with: finalPath)
                    
                    await MainActor.run {
                        withAnimation {
                            cropping = false
                            takenImage = croppedFace
                        }
                    }
                    
                } else {
                    // do nothing, no faces detected
                }
                
                // cancel task if nothing detected after 1s
                try await Task.sleep(for: .seconds(1))
                visionTask!.cancel()
            } catch {
                if let task = visionTask {
                    if !task.isCancelled {
                        print("Error in face detection: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    func detectFace(in image: CIImage) {
        // dont do anything if vision task running OR image has been taken already
        guard (visionTask == nil || visionTask?.isCancelled == true) && takenImage == nil else { return }
        
        visionTask = Task(priority: .userInitiated) {
            let request = DetectFaceRectanglesRequest()
            
            do {
                let points = try await request.perform(on: image).map { observation in
                    return observation
                }
                
                if let firstFace = points.first {
                    // get image size
                    let ciContext = CIContext()
                    guard let cgImage = ciContext.createCGImage(image, from: image.extent) else { print("cannot make cgimage;"); return }
                    let widthScale = displayImageSize.width / CGFloat(cgImage.width)
                    let heightScale = displayImageSize.height / CGFloat(cgImage.height)

                    let size = CGSize(width: cgImage.width, height: cgImage.height)
                    
                    let scaledBox = firstFace.boundingBox.toImageCoordinates(size)
                        .applying(.init(scaleX: widthScale, y: heightScale))
                    let box = scaledBox
                        .applying(.init(scaleX: 1, y: -1)
                            .translatedBy(x: 0, y: -(displayImageSize.height - safeAreaOffset)))
                        
                    await MainActor.run {
                        withAnimation {
                            faceBoxes = [box]
                        }
                    }
                } else {
                    // remove any face boxes
                    if faceBoxes != [] {
                        await MainActor.run {
                            withAnimation {
                                faceBoxes = []
                            }
                        }
                    }
                    
                }
                
                // cancel task if nothing detected after 0.25
                try await Task.sleep(for: .seconds(0.25))
                visionTask!.cancel()
            } catch {
                if let task = visionTask {
                    if !task.isCancelled {
                        print("Error in face detection: \(error.localizedDescription)")
                    }
                }

            }
        }
    }
    
    
    func cropFace(of image: CGImage, with facePath: CGPath) async -> Image  {
        // need bounding region and then my
        // the bounding path of the face point
        var pathImage: CGImage? = nil
        print(image.width, image.height)
        if let context = CGContext(data: nil, width: image.width, height: image.height, bitsPerComponent: image.bitsPerComponent, bytesPerRow: image.bytesPerRow, space: CGColorSpace(name: CGColorSpace.linearGray)!, bitmapInfo: image.bitmapInfo.rawValue) {
            // set rest of pixels to black
            context.setFillColor(gray: 0, alpha: 1)
            context.fill(.init(x: 0, y: 0, width: CGFloat(context.width), height: CGFloat(context.height)))
            
            // set mask of pixels to red
            context.addPath(facePath)
            context.setFillColor(gray: 1, alpha: 1)
            context.fillPath()
            
            pathImage = context.makeImage()
        }
        
        guard let pathImage else { print("making path image failed"); return Image(systemName: "exclamationmark.warninglight") }
        
        guard let crop = image.masking(pathImage) else { print("masking failed"); return Image(systemName: "exclamationmark.warninglight")}

        return Image(uiImage: UIImage(cgImage: crop, scale: 1.0, orientation: .right).cropAlpha())
    
        
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
        case .upMirrored: self = .up
        case .down: self = .up
        case .downMirrored: self = .up
        case .left: self = .up
        case .leftMirrored: self = .up
        case .right: self = .up
        case .rightMirrored: self = .up
        }
    }
}

fileprivate let logger = Logger(subsystem: "com.apple.swiftplaygroundscontent.capturingphotos", category: "DataModel")

public extension UIImage {
    
    func cropAlpha() -> UIImage {
        
        let cgImage = self.cgImage!;
        
        let width = cgImage.width
        let height = cgImage.height
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bytesPerPixel:Int = 4
        let bytesPerRow = bytesPerPixel * width
        let bitsPerComponent = 8
        let bitmapInfo: UInt32 = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue
        
        guard let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo),
            let ptr = context.data?.assumingMemoryBound(to: UInt8.self) else {
                return self
        }
        
        context.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        var minX = width
        var minY = height
        var maxX: Int = 0
        var maxY: Int = 0
        
        for x in 1 ..< width {
            for y in 1 ..< height {
                
                let i = bytesPerRow * Int(y) + bytesPerPixel * Int(x)
                let a = CGFloat(ptr[i + 3]) / 255.0
                
                if(a>0) {
                    if (x < minX) { minX = x };
                    if (x > maxX) { maxX = x };
                    if (y < minY) { minY = y};
                    if (y > maxY) { maxY = y};
                }
            }
        }
        
        let rect = CGRect(x: CGFloat(minX),y: CGFloat(minY), width: CGFloat(maxX-minX), height: CGFloat(maxY-minY))
        let imageScale:CGFloat = self.scale
        let croppedImage =  self.cgImage!.cropping(to: rect)!
        let ret = UIImage(cgImage: croppedImage, scale: imageScale, orientation: self.imageOrientation)
        
        return ret;
    }
    
}
