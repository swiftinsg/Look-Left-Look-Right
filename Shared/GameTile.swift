//
//  GameTile.swift
//  Look Left Look Right
//
//  Created by Jia Chen Yee on 5/5/25.
//

import Foundation

enum GameTile: Codable {
    case train(Train)
    case peaceful(TreePlacement)
    
    var isTrain: Bool {
        switch self {
        case .train: true
        case .peaceful: false
        }
    }
    
    var train: Train? {
        switch self {
        case .train(let train): train
        case .peaceful: nil
        }
    }
    
    static func random() -> Self {
        Bool.random() ? .train(.random()) : .peaceful(.random())
    }
}
