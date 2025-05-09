//
//  GameManager+Layout.swift
//  Camera
//
//  Created by Jia Chen Yee on 5/9/25.
//

import Foundation
import SceneKit
import ARKit

extension GameManager {
    func setUpLayout(_ layout: GameLayout) {
        trainNodes = [:]
        trainTrackNodes = [:]
        transparencyNodes = [:]
        
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
            let tileNode = SCNNode()
            
            tileNode.position = SCNVector3(0, 0, Double(index) * Constants.tileHeight)
            
            if tile.isTrain {
                setUpTrainTile(index: index, tileNode: tileNode)
            } else {
                setUpPeacefulTile(index: index, tile: tile, tileNode: tileNode)
            }
            
            rootNode.addChildNode(tileNode)
        }
        
        rootNode.addChildNode(setUpWalls())
        
        SCNTransaction.commit()
    }
    
    func setUpWalls() -> SCNNode {
        let wallHeight: Double = 2.0
        
        let wallNode = SCNNode()
        let backWallNode = SCNNode(geometry: SCNPlane(width: Constants.totalWidth, height: wallHeight))
        
        backWallNode.rotation = SCNVector4(0, 1, 0, Double.pi)
        backWallNode.position = SCNVector3(0, wallHeight / 2, Constants.height - Constants.tileHeight / 2)
        backWallNode.geometry?.firstMaterial?.diffuse.contents = UIColor.white
        
        wallNode.addChildNode(backWallNode)
        
        let leftWallNode = SCNNode(geometry: SCNPlane(width: Constants.height, height: wallHeight))
        
        leftWallNode.rotation = SCNVector4(0, 1, 0, -Double.pi / 2)
        leftWallNode.position = SCNVector3(Constants.totalWidth / 2,
                                           wallHeight / 2,
                                           Constants.height / 2 - Constants.tileHeight / 2)
        leftWallNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "Brick")!
        
        wallNode.addChildNode(leftWallNode)
        
        let rightWallNode = SCNNode(geometry: SCNPlane(width: Constants.height, height: wallHeight))
        
        rightWallNode.rotation = SCNVector4(0, 1, 0, Double.pi / 2)
        rightWallNode.position = SCNVector3(-Constants.totalWidth / 2,
                                            wallHeight / 2,
                                            Constants.height / 2 - Constants.tileHeight / 2)
        rightWallNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "Brick")!
        
        wallNode.addChildNode(rightWallNode)
        
        wallNode.name = "Walls"
        
        return wallNode
    }
}
