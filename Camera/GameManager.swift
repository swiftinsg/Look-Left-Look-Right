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

@Observable
@MainActor
final class GameManager: NSObject, Sendable {
    @ObservationIgnored
    var rootNode: SCNNode = SCNNode()
    
    var layout: GameLayout?
    
    func setUpLayout(_ layout: GameLayout) {
        self.layout = layout
        rootNode.position = SCNVector3(-Constants.totalWidth / 2 + Constants.imageAnchorWidth / 2,
                                        0,
                                        Constants.imageAnchorWidth / 2)
        
        SCNTransaction.begin()
        
        // remove existing tiles
        for node in rootNode.childNodes {
            node.removeFromParentNode()
        }
        
        for (index, tile) in layout.tiles.enumerated() {
            let planeNode = SCNNode(geometry: SCNPlane(width: Constants.totalWidth, height: Constants.tileHeight))
            planeNode.rotation = SCNVector4(x: -1, y: 0, z: 0, w: .pi / 2)
            
            let floorMaterial = SCNMaterial()
            
            floorMaterial.transparency = 0.5
            
            if tile.isTrain {
                floorMaterial.diffuse.contents = UIColor.lightGray
            } else {
                floorMaterial.diffuse.contents = UIColor.green
            }
            
            if index == 0 {
                floorMaterial.diffuse.contents = UIColor.red
            }
            
            planeNode.geometry?.firstMaterial = floorMaterial
            
            planeNode.position = SCNVector3(0, 0, Double(index) * Constants.tileHeight)
            
            rootNode.addChildNode(planeNode)
        }
        
        SCNTransaction.commit()
    }
}

extension GameManager: ARSCNViewDelegate {
    nonisolated func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARImageAnchor else { return }
        
        Task {
            await node.addChildNode(rootNode)
        }
    }
    
    nonisolated func renderer(_ renderer: any SCNSceneRenderer, updateAtTime time: TimeInterval) {
        print("skibidi")
    }
    
    nonisolated func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARImageAnchor else { return }
        
        Task {
            await node.addChildNode(rootNode)
        }
    }
}
