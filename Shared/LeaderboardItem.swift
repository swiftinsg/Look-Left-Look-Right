//
//  LeaderboardItem.swift
//  Look Left Look Right
//
//  Created by Tristan Chay on 9/5/25.
//

import Foundation

struct LeaderboardItem: Identifiable, Equatable, Codable {
    var id: String { index }

    var index: String
    var name: String
    var image: Data
    var group: Group
    var timing: Int
    
    
}

#if canImport(AppKit)
import AppKit

extension LeaderboardItem {
    var nsImage: NSImage {
        NSImage(data: image)!
    }
}
#endif
