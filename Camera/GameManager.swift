//
//  GameManager.swift
//  Camera
//
//  Created by Jia Chen Yee on 5/5/25.
//

import Foundation
import Observation
import ARKit
import SwiftUI
import ModelIO

@Observable
@MainActor
final class GameManager: NSObject, Sendable {
    @ObservationIgnored
    var rootNode: SCNNode = SCNNode()
    
    var layout: GameLayout?
    
    var trainNodes: [Int: SCNNode] = [:]
}
