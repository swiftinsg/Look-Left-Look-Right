//
//  GameManager.swift
//  Camera
//
//  Created by Jia Chen Yee on 5/5/25.
//

import Foundation
import Observation
import ARKit

@Observable
@MainActor
final class GameManager: NSObject, Sendable {
    @ObservationIgnored
    var rootNode: SCNNode = SCNNode()
    
    var layout: GameLayout?
    
    func setUpLayout(_ layout: GameLayout) {
        self.layout = layout
        
        
    }
}

extension GameManager: ARSCNViewDelegate {
    nonisolated func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARImageAnchor else { return }
        
        Task {
            await node.addChildNode(rootNode)
        }
    }
    
    nonisolated func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARImageAnchor else { return }
        
        Task {
            await node.addChildNode(rootNode)
        }
    }
}
