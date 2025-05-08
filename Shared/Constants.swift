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
    
    // In meters, the length of a single train car
    static let trainCarLength: Double = 1.0
    
    // In meters
    static let trainCarHeight: Double = 0.58
    
    // In meters
    static let trackHeight: Double = 0.12
    
    // In meters
    // If train is >1 car long, it needs a linker between each car
    static let trainCarLinkerLength: Double = 0.1
    
    // In meters
    static var tileHeight: Double {
        height / Double(numberOfFloorTiles)
    }
    
    static var crashRange: ClosedRange<Double> {
        totalWidth / 2 - playableWidth / 2 ... (totalWidth - (totalWidth / 2 - playableWidth / 2))
    }
    
    // In meters
    static let imageAnchorWidth: Double = 0.25
    
    static let sleeperWidth: Double = 0.05
    
    static let sleeperHeight: Double = 0.02
    
    static let tieGap: Double = 0.1
    
    static let barkHeight: Double = 0.7
    static let treeDiameter: Double = 0.08
    static let treeLeafDiameter: Double = 0.4
}
