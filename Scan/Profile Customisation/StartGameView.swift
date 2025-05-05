//
//  CustomiseProfileView.swift
//  Scan
//
//  Created by Sean on 6/5/25.
//

import SwiftUI

struct StartGameView: View {
    @Binding var student: StudentExport?
    @State var appState: AppState = .profileSetup

    var ip: String
    var body: some View {
        
        switch appState {
        case .profileSetup:
            WelcomeProfileView(student: $student, appState: $appState, ip: ip)
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
    case profileSetup
    case loading
    case start
    case occupied
    case error
}
