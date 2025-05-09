//
//  CustomiseProfileView.swift
//  Scan
//
//  Created by Sean on 6/5/25.
//

import SwiftUI

struct StartGameView: View {
    @Binding var student: StudentExport?
    @Binding var appState: AppState 
    @Environment(DataModel.self) private var model
    var ip: String
    var body: some View {
        
        switch appState {
        case .manualInput:
            ManualInputView(appState: $appState, student: $student)
        case .selectStudent:
            StudentsView(students: StudentExport.sampleData, selectedStudent: $student, appState: $appState)
        case .profileSetup:
            WelcomeProfileView(student: $student, appState: $appState, ip: ip)
                .environment(model)
        case .loading:
            ProgressView("Loading...")
        case .start:
            GameStartSuccessView(student: $student)
        case .error:
            VStack {
                Text("An error occured.")
                Button("Try again") {
                    appState = .profileSetup
                }
                .padding()
                
            }
        case .occupied:
            OccupiedView(appState: $appState)
        }
        
    }
}


enum AppState {
    // Add manual input case here? For alumni
    case manualInput
    case selectStudent
    case profileSetup
    case loading
    case start
    case occupied
    case error
}
