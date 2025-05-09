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
            
            if gameManager.isUserDead {
                Rectangle()
                    .stroke(Color.red)
                    .shadow(color: .red, radius: 20, x: 0, y: 0)
                    .shadow(color: .red, radius: 20, x: 0, y: 0)
                    .shadow(color: .red, radius: 20, x: 0, y: 0)
                    .shadow(color: .red, radius: 20, x: 0, y: 0)
                    .ignoresSafeArea()
                
                Text(gameManager.deathMessage)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .frame(maxHeight: .infinity, alignment: .top)
            }
        }
        .persistentSystemOverlays(.hidden)
        .statusBarHidden()
        .task {
            await gameManager.startHeartbeatMessages()
        }
    }
}

#Preview {
    ContentView()
}
