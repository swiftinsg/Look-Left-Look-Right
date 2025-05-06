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
                        faceImage
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 300)
                    } else {
                        // No image taken means no face detected, just show viewfinder
                        VStack {
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 300, height: 300)
                            Text("Make sure your face is in frame!")
                                .font(.caption)
                        }
                        
                    }
                    
                }
                    
                Text(student.name)
                    .font(.headline)
                    .padding()
                Button("Start Game") {
                    let sendData = ScanEntry(student: student)
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
            }
            .task {
                await model.camera.start()
            }
        }
    }
}
