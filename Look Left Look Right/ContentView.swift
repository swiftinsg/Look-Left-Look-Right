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
            HSplitView {
                VStack(alignment: .leading) {
                    Text("floor-server communication")
                        .font(.title)
                    VStack(spacing: 0) {
                        ForEach(0..<Constants.numberOfFloorTiles, id: \.self) { tileIndex in
                            let effectiveIndex = Constants.numberOfFloorTiles - tileIndex - 1
                            
                            let tile = server.floorTiles[effectiveIndex]
                            
                            Button {
                                server.floorTiles[effectiveIndex].gotHuman.toggle()
                                server.floorTiles[effectiveIndex].date = .now
                            } label: {
                                Rectangle()
                                    .fill(tile.gotHuman ? .blue : .clear)
                                    .overlay {
                                        Rectangle()
                                            .stroke(lineWidth: 1)
                                        
                                        Text(tile.date.formatted(date: .omitted, time: .complete))
                                    }
                            }
                            .buttonStyle(.plain)
                            .keyboardShortcut(KeyEquivalent(Character("\(effectiveIndex == 0 ? "`" : String(effectiveIndex))")))
                        }
                    }
                }
                
                VStack {
                    HStack {
                        Text("game layout")
                            .font(.title)
                        Spacer()
                        Button("end game / regenerate") {
                            server.currentUser = nil
                            server.gameLayout = .random()
                            server.isUserDead = false
                            server.needsToResendGameLayoutInHeartbeat = true
                        }
                    }
                    GameLayoutPreviewView()
                }
            }
            .navigationTitle("Debug View")
        }
        .padding()
        .task {
            await server.start()
        }
        .environment(server)
    }
}

#Preview {
    ContentView()
}
