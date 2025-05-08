//
//  OccupiedVieqw.swift
//  Scan
//
//  Created by Sean on 6/5/25.
//

import SwiftUI

struct OccupiedView: View {
    @Binding var appState: AppState
    var body: some View {
        VStack {
            Text("Someone's playing already! Try again later.")
                .padding()
            Button("Back") {
                appState = .profileSetup
            }
        }
        
        
    }
}

