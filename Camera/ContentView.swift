//
//  ContentView.swift
//  Camera
//
//  Created by Jia Chen Yee on 5/5/25.
//

import SwiftUI

struct ContentView: View {
    
    @State private var gameManager = GameManager()
    
    var body: some View {
        ARView(gameManager: gameManager)
            .ignoresSafeArea()
    }
}

#Preview {
    ContentView()
}
