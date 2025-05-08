//
//  GameLayout.swift
//  Look Left Look Right
//
//  Created by Jia Chen Yee on 5/5/25.
//

import Foundation

struct GameLayout: Codable {
    
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
    
    init(tiles: [GameTile]) {
        self.tiles = tiles
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let gameStartTime = try? container.decode(Date.self, forKey: .gameStartTime) {
            self.gameStartTime = gameStartTime
        } else {
            let dateString = try container.decode(String.self, forKey: .gameStartTime)
            if let date = ISO8601DateFormatter().date(from: dateString) {
                self.gameStartTime = date
            } else {
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Invalid date format"))
            }
        }
        
        self.tiles = try container.decode([GameTile].self, forKey: .tiles)
    }
}

#if canImport(Vapor)
import Vapor

extension GameLayout: Content {}
#endif
