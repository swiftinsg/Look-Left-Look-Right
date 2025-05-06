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
    @Binding var ipAddress: String
    var students: [StudentExport]
    @State var scannedStudent: StudentExport?
    
    var body: some View {
        VStack {
            Button {
                isScannerShown = true
            } label: {
                VStack {
                    Image(systemName: "person")
                        .imageScale(.large)
                    Text("Student")
                }
                .padding()
                
            }
            .padding()
            .buttonStyle(.borderedProminent)
            Button {
                isScannerShown = true
                isAlumni = true
            } label: {
                VStack {
                    Image(systemName: "graduationcap")
                        .imageScale(.large)
                    Text("Alumni")
                }
                .padding()
            }
            .buttonStyle(.borderedProminent)
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
        } content: {
            StartGameView(student: $scannedStudent, ip: ipAddress)
        }

    }
    
}
