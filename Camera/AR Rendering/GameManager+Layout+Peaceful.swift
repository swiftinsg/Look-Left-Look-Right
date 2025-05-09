//
//  GameManager+Layout+Peaceful.swift
//  Camera
//
//  Created by Jia Chen Yee on 5/9/25.
//

import Foundation
import ARKit
import SpriteKit

extension GameManager {
    func setUpPeacefulTile(index: Int, tile: GameTile, tileNode: SCNNode) {
        tileNode.addChildNode(createFloor())
        
        if let tree = tile.tree, tree != .noTree {
            let treeNode = createTree(tree)
            tileNode.addChildNode(treeNode)
            
            transparencyNodes[index] = [treeNode]
        }
    }
    
    fileprivate func createFloor() -> SCNNode {
        let planeNode = SCNNode(geometry: SCNPlane(width: Constants.totalWidth, height: Constants.tileHeight))
        planeNode.rotation = SCNVector4(x: -1, y: 0, z: 0, w: .pi / 2)
        
        let floorMaterial = SCNMaterial()
        
        floorMaterial.diffuse.contents = UIColor(red: 128/255, green: 194/255, blue: 112/255, alpha: 1)
        
        planeNode.geometry?.firstMaterial = floorMaterial
        
        return planeNode
    }
    
    fileprivate func createTree(_ placement: GameTile.TreePlacement) -> SCNNode {
        let treeNode = SCNNode()
        
        let barkNode = SCNNode(geometry: SCNBox(width: Constants.treeDiameter,
                                                height: Constants.barkHeight,
                                                length: Constants.treeDiameter, chamferRadius: 0))
        
        let barkMaterial = SCNMaterial()
        barkMaterial.diffuse.contents = UIColor.brown
        
        barkNode.geometry?.firstMaterial = barkMaterial
        barkNode.geometry?.firstMaterial?.isDoubleSided = true
        
        barkNode.position.y = Float(Constants.barkHeight / 2)
        
        treeNode.addChildNode(barkNode)
        
        treeNode.addChildNode(createTreeLeafLayer(index: 0))
        treeNode.addChildNode(createTreeLeafLayer(index: 1))
        treeNode.addChildNode(createTreeLeafLayer(index: 2))
        
        if placement == .left {
            treeNode.position.x = Float(-Constants.totalWidth / 2 + 0.3)
        } else {
            treeNode.position.x = Float(Constants.totalWidth / 2 - 0.3)
        }
        
        return treeNode
    }
    
    fileprivate func createTreeLeafLayer(index: Int) -> SCNNode {
        let treeLeafNode = SCNNode(geometry: SCNBox(width: Constants.treeLeafDiameter,
                                                    height: 0.2,
                                                    length: Constants.treeLeafDiameter, chamferRadius: 0))
        
        let leafMaterial = SCNMaterial()
        
        let greens = [UIColor(red: 97/255, green: 110/255, blue: 40/255, alpha: 1),
                      UIColor(red: 107/255, green: 121/255, blue: 47/255, alpha: 1)]
        
        leafMaterial.diffuse.contents = greens[index % 2]
        
        treeLeafNode.geometry?.firstMaterial = leafMaterial
        treeLeafNode.geometry?.firstMaterial?.isDoubleSided = true
        
        treeLeafNode.position = SCNVector3(0, Constants.barkHeight + CGFloat(index) * 0.2, 0)
        
        return treeLeafNode
    }
}
