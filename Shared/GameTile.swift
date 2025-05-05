//
//  GameTile.swift
//  Look Left Look Right
//
//  Created by Jia Chen Yee on 5/5/25.
//

import Foundation
import SwiftUI

enum GameTile: Codable {
    case train(Train)
    case peaceful(TreePlacement)
    
    var isTrain: Bool {
        switch self {
        case .train: true
        case .peaceful: false
        }
    }
    
    static func random() -> Self {
        Bool.random() ? .train(.random()) : .peaceful(.random())
    }
    
    enum TreePlacement: Int, CaseIterable, Codable {
        case noTree
        case left
        case right
        
        static func random() -> Self {
            allCases.randomElement()!
        }
        
        func toSwiftUIAlignment() -> Alignment? {
            switch self {
            case .noTree: nil
            case .left: .leading
            case .right: .trailing
            }
        }
    }
    
    struct Train: Codable {
        var id = UUID()
        
        // can be +ve or -ve, just to represent how far along the "run over animation" the train starts off with
        var startTimeOffset: TimeInterval
        
        // the train runs every x seconds
        var frequency: TimeInterval
        
        // how fast train move (m/s)
        var speed: Double
        
        // how long is the train car
        var cars: Int
        
        // is the train coming from lhs or rhs
        var direction: Direction
        
        enum Direction: Int, Equatable, Codable {
            case left
            case right
            
            static func random() -> Self {
                Bool.random() ? .left : .right
            }
        }
        
        static func random() -> Self {
            let frequency: TimeInterval = .random(in: 3...8)
            let speed: Double = .random(in: 1...5)
            let cars: Int = Int.random(in: 1...3)
            let startTimeOffset = TimeInterval.random(in: -frequency...frequency)
            
            return Train(startTimeOffset: startTimeOffset, frequency: frequency, speed: speed, cars: cars, direction: .random())
        }
    }
}

