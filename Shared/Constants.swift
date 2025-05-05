//
//  Constants.swift
//  Look Left Look Right
//
//  Created by Jia Chen Yee on 5/4/25.
//

import Foundation

enum Constants: Sendable {
    static let numberOfFloorTiles: Int = 9
    
    // Think of the set up like this
    //
    // a = playableWidth
    // b = totalWidth
    // c = height
    //
    //      <-a->
    // <------b------>
    // |    |   |    | /|\
    // |    |   |    |  |
    // *    *   *    *  |
    // *    *   *    *  | c
    // *    *   *    *  |
    // |    |   |    |  |
    // |    |   |    | \|/
    
    // Playable area, think of this as the space the user stands in
    // In meters
    static let playableWidth: Double = 0.5
    
    // Outside of this bounds, walls will be created
    static let totalWidth: Double = 2.5
    
    // In meters
    static let height: Double = 4.5
    
    // In meters
    static var tileHeight: Double {
        height / Double(numberOfFloorTiles)
    }
}
