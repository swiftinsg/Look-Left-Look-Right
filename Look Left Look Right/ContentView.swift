//
//  ContentView.swift
//  Look Left Look Right
//
//  Created by Jia Chen Yee on 5/4/25.
//

import SwiftUI

struct ContentView: View {
    
    @State private var server = Server()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ForEach(server.floorTiles.reversed()) { tile in
                    Rectangle()
                        .fill(tile.gotHuman ? .blue : .clear)
                        .overlay {
                            Rectangle()
                                .stroke(lineWidth: 1)
                            
                            Text(tile.date.formatted(date: .omitted, time: .complete))
                        }
                }
            }
            .navigationTitle("Debug View")
        }
        .padding()
        .task {
            await server.start()
        }
    }
}

#Preview {
    ContentView()
}
