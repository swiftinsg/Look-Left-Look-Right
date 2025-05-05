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
                    TileView(tileIndex: tileIndex)
                    
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
