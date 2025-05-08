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
    @State var appState: AppState = .profileSetup
    var students: [StudentExport]
    @State var scannedStudent: StudentExport?
    
    var body: some View {
        HStack {
            VStack {
                Button {
                    isScannerShown = true
                } label: {
                    VStack {
                        Image(systemName: "barcode.viewfinder")
                            .imageScale(.large)
                        Text("Scan")
                    }
                    .padding()
                    
                }
                .padding()
                .buttonStyle(.borderedProminent)
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
                    
                }
                .padding()
                .buttonStyle(.borderedProminent)
                
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
            }
            .buttonStyle(.borderedProminent)
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
            isTest = false
        } content: {
            StartGameView(student: $scannedStudent, appState: $appState, ip: ipAddress)
            
            
        }
        
    }
    
}
