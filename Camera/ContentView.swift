//
//  ContentView.swift
//  Camera
//
//  Created by Jia Chen Yee on 5/5/25.
//

import SwiftUI
import RegexBuilder

struct ContentView: View {
    
    @State private var gameManager = GameManager()
    
    var body: some View {
        ZStack {
            ARView(gameManager: gameManager)
                .ignoresSafeArea()
            Button("Simulate Layout Load") {
                gameManager.setUpLayout(.random())
            }
        }
    }
}

#Preview {
    ContentView()
}
