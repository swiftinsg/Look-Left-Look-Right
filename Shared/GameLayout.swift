//
//  GameLayout.swift
//  Look Left Look Right
//
//  Created by Jia Chen Yee on 5/5/25.
//

import Foundation

struct GameLayout {
    
    var gameStartTime: Date = .now
    var tiles: [GameTile]
    
    static func random() -> Self {
        var tiles: [GameTile] = [
            .peaceful(.random())
        ]
        
        for i in 1..<Constants.numberOfFloorTiles {
            let previousTile = tiles[i - 1]
            
            // if previous tile is peaceful, the next one should be a train
            if !previousTile.isTrain {
                tiles.append(.train(.random()))
                continue
            }
            
            // max of 2 consecutive train lines before a peaceful is required
            if tiles.count > 1 && tiles[tiles.count - 2].isTrain {
                tiles.append(.peaceful(.random()))
                continue
            }
            
            // otherwise any tile will work
            tiles.append(.random())
        }
        
        return .init(tiles: tiles.reversed())
    }
}

#if canImport(Vapor)
import Vapor

extension GameLayout: Content {}
#endif
