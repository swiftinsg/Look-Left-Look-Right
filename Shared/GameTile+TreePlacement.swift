//
//  GameTile+Peaceful.swift
//  Look Left Look Right
//
//  Created by Jia Chen Yee on 5/5/25.
//

import Foundation
import SwiftUI

extension GameTile {
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
}
