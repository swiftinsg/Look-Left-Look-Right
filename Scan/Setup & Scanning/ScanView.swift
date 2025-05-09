//
//  ScanView.swift
//  Scan
//
//  Created by Sean on 5/5/25.
//

import SwiftUI
import SwiftUINFC

struct ScanView: View {
    @State var isScannerShown: Bool = false
    @State var isAlumni: Bool = false
    @State var showingProfileSheet: Bool = false
    @State var isTest: Bool = false
    @Binding var ipAddress: String
    
    @State var dataModel = DataModel()
    
    @State var appState: AppState = .profileSetup
    var students: [StudentExport]
    @State var scannedStudent: StudentExport?
    
    var body: some View {
        VStack {
            Button {
                isScannerShown = true
            } label: {
                VStack {
                    Image(systemName: "iphone.gen3.crop.circle")
                        .imageScale(.large)
                    Text("Scan")
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.roundedRectangle(radius: 8))
            
            HStack {
                Button {
                    appState = .selectStudent
                    showingProfileSheet = true
                } label: {
                    VStack {
                        Image(systemName: "person")
                            .imageScale(.large)
                        Text("Select Name")
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                
                Button {
                    showingProfileSheet = true
                    appState = .manualInput
                } label: {
                    VStack {
                        Image(systemName: "graduationcap")
                            .imageScale(.large)
                        Text("Alumni")
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .buttonStyle(.bordered)
            .buttonBorderShape(.roundedRectangle(radius: 8))
            
            //            Button {
            //                scannedStudent = .init(uuid: UUID(), indexNumber: "AM01", name: "Test student")
            //                showingProfileSheet = true
            //            } label: {
            //                VStack {
            //                    Image(systemName: "gear")
            //                        .imageScale(.large)
            //                    Text("Test")
            //                }
            //                .padding()
            //            }
            //            .buttonStyle(.borderedProminent)
        }
        .font(.title)
        .padding()
        .nfcReader(isPresented: $isScannerShown) { messages in
            guard let message = messages.first,
                  let record = message.records.first, let studentUUID = UUID(uuidString: String(decoding: record.payload, as: UTF8.self)) else {
                UINotificationFeedbackGenerator().notificationOccurred(.error)
                return "This is not a student badge."
            }
            
            guard let foundStudent = students.first(where: { student in
                student.uuid == studentUUID
            }) else {
                return "Student not found"
            }
            scannedStudent = foundStudent
            showingProfileSheet = true
            return "Welcome, \(foundStudent.name)!"
        } onFailure: { error in
            print(error.localizedDescription)
            return error.localizedDescription
        }
        .fullScreenCover(isPresented: $showingProfileSheet) {
            // clear scanned student
            scannedStudent = nil
            dataModel.takenImage = nil
            dataModel.faceBoxes = []
            isTest = false
        } content: {
            StartGameView(student: $scannedStudent, appState: $appState, ip: ipAddress)
                .environment(dataModel)
        }
        .task {
            if !dataModel.camera.isRunning {
                print("starting camera")
                await dataModel.camera.start()
            }
        }
    }
    
}
