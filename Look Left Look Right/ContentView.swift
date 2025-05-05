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
                }
                
                VStack {
                    HStack {
                        Text("game layout")
                            .font(.title)
                        Spacer()
                        Button("regenerate") {
                            server.gameLayout = .random()
                        }
                    }
                    VStack(spacing: 0) {
                        ForEach(0..<Constants.numberOfFloorTiles, id: \.self) { tileIndex in
                            
                            switch server.gameLayout.tiles[Constants.numberOfFloorTiles - tileIndex - 1] {
                            case .peaceful(let tree):
                                Rectangle()
                                    .fill(.green)
                                    .overlay {
                                        if let alignment = tree.toSwiftUIAlignment() {
                                            Image(systemName: "tree.fill")
                                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
                                                .font(.largeTitle)
                                                .foregroundStyle(.black)
                                        }
                                    }
                            case .train(let train):
                                Rectangle()
                                    .fill(.red)
                            }
                        }
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
