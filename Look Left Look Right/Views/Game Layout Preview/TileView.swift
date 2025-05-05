//
//  TileView.swift
//  Look Left Look Right
//
//  Created by Jia Chen Yee on 5/5/25.
//

import SwiftUI

struct TileView: View {
    
    @Environment(Server.self) var server
    
    var tileIndex: Int
    
    var body: some View {
        ZStack {
            switch server.gameLayout.tiles[tileIndex] {
            case .peaceful(let tree):
                Rectangle()
                    .fill(.green)
                    .overlay {
                        if let alignment = tree.toSwiftUIAlignment() {
                            TreeView()
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
                        }
                    }
            case .train(let train):
                TrainPreviewView(train: train)
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
        }
    }
}
