//
//  GameLayoutPreviewView.swift
//  Look Left Look Right
//
//  Created by Jia Chen Yee on 5/5/25.
//

import SwiftUI

struct GameLayoutPreviewView: View {
    
    @Environment(Server.self) var server
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<Constants.numberOfFloorTiles, id: \.self) { index in
                let tileIndex = Constants.numberOfFloorTiles - index - 1
                
                ZStack {
                    switch server.gameLayout.tiles[tileIndex] {
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
                            .fill(.gray)
                    }
                    Rectangle()
                        .stroke(Color.black, lineWidth: 1)
                    
                    HStack(spacing: 0) {
                        Rectangle().fill(.clear)
                        Rectangle().fill(.clear)
                        Rectangle()
                            .fill(.white)
                            .opacity(0.3)
                        Rectangle().fill(.clear)
                        Rectangle().fill(.clear)
                    }
                    
                    if server.userCurrentTile == tileIndex {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(.white, .blue, .blue)
                            .padding()
                    }
                }
            }
        }
        .aspectRatio(Constants.totalWidth / Constants.height, contentMode: .fit)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
