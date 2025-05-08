//
//  GameManager+ARSCNViewDelegate.swift
//  Camera
//
//  Created by Jia Chen Yee on 5/9/25.
//

import Foundation
import SceneKit
import ARKit

extension GameManager: ARSCNViewDelegate {
    nonisolated func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARImageAnchor else { return }
        
        Task {
            await node.addChildNode(rootNode)
        }
    }
    
    nonisolated func renderer(_ renderer: any SCNSceneRenderer, updateAtTime time: TimeInterval) {
        Task {
            await updatePositionsOfTrains()
        }
    }
    
    func updatePositionsOfTrains() {
        guard let layout = layout else { return }
        
        for (index, tile) in layout.tiles.enumerated() {
            if let train = tile.train {
                let position = train.position(for: layout.gameStartTime, currentTime: .now) ?? 10
                
                guard let trainNode = trainNodes[index] else { continue }
                
                #warning("need to verify")
                trainNode.position = SCNVector3(0.75 - position,
                                                Constants.trainCarHeight / 2 + Constants.sleeperHeight,
                                                0)
            }
        }
    }
    
    nonisolated func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARImageAnchor else { return }
        
        Task {
            await node.addChildNode(rootNode)
        }
    }
}
