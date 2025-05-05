//
//  TrainPreviewView.swift
//  Look Left Look Right
//
//  Created by Jia Chen Yee on 5/5/25.
//

import SwiftUI

struct TrainPreviewView: View {
    
    @Environment(Server.self) var server
    
    var index: Int
    var train: GameTile.Train
    
    @State private var metersPerPixel = 10.0
    
    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .fill(.gray.mix(with: .white, by: 0.5))
            
            Image(.tracks)
                .resizable()
                .scaledToFit()
                .overlay(alignment: .leading) {
                }
            
            let totalLength = metersPerPixel * (Constants.trainCarLength * Double(train.cars) + Constants.trainCarLinkerLength * Double(train.cars - 1))
            
            let totalHeight = metersPerPixel * Constants.height / Double(Constants.numberOfFloorTiles)
            
            HStack(spacing: 0) {
                Rectangle()
                    .fill(.red)
                    .frame(width: metersPerPixel * Constants.trainCarLength)
                
                if train.cars > 1 {
                    Rectangle()
                        .fill(.red)
                        .frame(width: metersPerPixel * Constants.trainCarLinkerLength, height: 10)
                    
                    Rectangle()
                        .fill(.red)
                        .frame(width: metersPerPixel * Constants.trainCarLength)
                }
                
                if train.cars > 2 {
                    Rectangle()
                        .fill(.red)
                        .frame(width: metersPerPixel * Constants.trainCarLinkerLength, height: 10)
                    
                    Rectangle()
                        .fill(.red)
                        .frame(width: metersPerPixel * Constants.trainCarLength)
                }
            }
            .padding(.vertical)
            .position(x: totalLength / 2 + (server.trainPositions[index] ?? 0.0) * metersPerPixel, y: totalHeight / 2)
        }
        .onGeometryChange(for: Double.self) { proxy in
            proxy.size.width
        } action: { newValue in
            metersPerPixel = newValue / Constants.totalWidth
        }
        .clipped()
    }
}
