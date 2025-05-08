//
//  WelcomeProfileCView.swift
//  Scan
//
//  Created by Sean on 6/5/25.
//

import SwiftUI
import Vision
struct WelcomeProfileView: View {
    @Binding var student: StudentExport?
    @Binding var appState: AppState
    
    @StateObject private var model = DataModel()
    var ip: String
    var body: some View {
        if let student {
            VStack {
                if let image = model.viewfinderImage {
                    if let faceImage = model.takenImage {
                        ZStack {
                            
                            faceImage
                                .resizable()
                                .scaledToFit()
                                .padding()
                        }
                        
                    } else {
                        // No image taken means no face detected, just show viewfinder
                        ZStack {
                            VStack {
                                image
                                    .resizable()
                                    .scaledToFit()
                                Text("Make sure your face is in frame!")
                                    .font(.caption)
                                    .padding()
                                Spacer()
                            }
                            if let firstFaceBox = model.faceBoxes.first {
                                Path(firstFaceBox)
                                    .stroke(Color.red)
                                    .onAppear {
                                        print(firstFaceBox)
                                    }
                                    .overlay(imageReader())
                            }
                            
                            
                        }
                        
                    }
                }
                if model.cropping {
                    ProgressView {
                        Text("Cropping the image...")
                    }
                }
                Text(student.name)
                    .font(.headline)
                    .padding()
                if model.takenImage != nil {
                    Button("Re-take Image", role: .destructive) {
                        model.takenImage = nil
                    }
                    Button("Start Game") {
                        var sendData = ScanEntry(student: student)
                        if let image = model.takenImage {
                            Task {
                                do {
                                    sendData.image = try await image.exported(as: .png)
                                } catch {
                                    print(error.localizedDescription)
                                }
                            }
                            
                        }
                        
                        var urlRequest = URLRequest(url: URL(string: "http://\(ip.self):8080/scan")!)
                        let jsonEncoder = JSONEncoder()
                        jsonEncoder.outputFormatting = [.withoutEscapingSlashes]
                        let json = try! jsonEncoder.encode(sendData)
                        print(String(data: json, encoding: .utf8)!)
                        urlRequest.httpBody = json
                        urlRequest.httpMethod = "POST"
                        urlRequest.timeoutInterval = 1
                        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                        appState = .loading
                        URLSession.shared.dataTask(with: urlRequest) { data, _, error in
                            if let error {
                                print(error.localizedDescription)
                                appState = .error
                                return
                            }
                            if let data {
                                let response = String(data: data, encoding: .utf8)!
                                if response == "goaway" {
                                    appState = .occupied
                                    return
                                }
                                appState = .start
                            }
                        }.resume()
                        
                    }
                    .disabled(model.takenImage == nil)
                    .padding()
                    .buttonStyle(.borderedProminent)
                } else {
                    
                    Button("Take Picture") {
                        model.camera.takePhoto()
                    }
                    .disabled(model.cropping)
                    .buttonStyle(.borderedProminent)
                }
                
                
            }
            .task {
                await model.camera.start()
            }
            .onDisappear {
                model.camera.stop()
            }
        } else {
            Text("No student!!!!")
        }
    }
    
    private func imageReader() -> some View {
        return GeometryReader { proxy in
            if model.displayImageSize == .zero {
                DispatchQueue.main.async {
                    model.displayImageSize = proxy.size
                    // add in safe area height i think
                    model.safeAreaOffset = proxy.frame(in: .global).minY
                }
            }
            return Color.clear
        }
    }
}
