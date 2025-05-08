//
//  ManualInputView.swift
//  Scan
//
//  Created by Sean on 9/5/25.
//

import SwiftUI

struct ManualInputView: View {
    @State var name: String = ""
    @Binding var appState: AppState
    @Binding var student: StudentExport?
    var body: some View {
        VStack {
            TextField("Your name", text: $name)
                .padding()
            Button("Sign in") {
                student = StudentExport(uuid: UUID(), indexNumber: "NOT AN INDEX NUMBER THIS WILL BE ALUMNI", name: name)
                appState = .profileSetup
            }
            
        }
        
        
    }
}
