//
//  GameLayoutPreviewView.swift
//  Look Left Look Right
//
//  Created by Jia Chen Yee on 5/5/25.
//

import SwiftUI

struct GameLayoutPreviewView: View {
    
    var gameLayout: GameLayout
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<Constants.numberOfFloorTiles, id: \.self) { tileIndex in
                
                switch gameLayout.tiles[Constants.numberOfFloorTiles - tileIndex - 1] {
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
