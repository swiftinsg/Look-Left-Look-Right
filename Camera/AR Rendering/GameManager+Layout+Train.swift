//
//  GameManager+Layout+Train.swift
//  Camera
//
//  Created by Jia Chen Yee on 5/9/25.
//

import Foundation
import ARKit
import SceneKit
import UIKit

extension GameManager {
    func setUpTrainTile(index: Int, tileNode: SCNNode) {
        let trainNode = createTrainNode()
        tileNode.addChildNode(trainNode)
        trainNodes[index] = trainNode
        
        transparencyNodes[index] = [trainNode]
        
        let trackNode = createTrackNode()
        
        tileNode.addChildNode(trackNode)
        
        let tunnelNode = setUpTunnels()
        
        tileNode.addChildNode(tunnelNode)
    }
    
    fileprivate func createTrainNode() -> SCNNode {
        let scene = SCNScene(named: "train.usdz")!
        let trainNode = scene.rootNode.childNodes[0]
        
        trainNode.name = "train"
        
        trainNode.rotation = SCNVector4(x: -1, y: 0, z: 0, w: .pi / 2)
        trainNode.position = SCNVector3(0.75, Constants.trainCarHeight / 2 + Constants.sleeperHeight, 0)
        
        return trainNode
    }
    
    fileprivate func createTrackNode() -> SCNNode {
        let trackRootNode = SCNNode()
        
        // create sleepers
        for i in 0..<16 {
            trackRootNode.addChildNode(createSleeperNode(for: i))
        }
        
        trackRootNode.addChildNode(createTieNode(isTop: true))
        trackRootNode.addChildNode(createTieNode(isTop: false))
        
        return trackRootNode
    }
    
    fileprivate func createSleeperNode(for index: Int) -> SCNNode {
        let trackGap = Constants.totalWidth / 16
        
        let leadingGap = trackGap * Double(index) + trackGap / 2
        
        let sleeperNode = SCNNode(geometry: SCNBox(width: Constants.sleeperWidth, height: Constants.sleeperHeight, length: Constants.tileHeight - 0.1, chamferRadius: 0))
        
        sleeperNode.position = SCNVector3(leadingGap - Constants.totalWidth / 2, 0, 0)
        
        sleeperNode.geometry?.firstMaterial?.diffuse.contents = UIColor.brown
        
        return sleeperNode
    }
    
    fileprivate func createTieNode(isTop: Bool) -> SCNNode {
        let tieNode = SCNNode(geometry: SCNBox(width: Constants.totalWidth, height: Constants.sleeperHeight, length: Constants.sleeperHeight, chamferRadius: 0))
        
        tieNode.position = SCNVector3(0, Constants.sleeperHeight, isTop ? Constants.tileHeight / 2 - Constants.tieGap : -Constants.tileHeight / 2 + Constants.tieGap)
        
        tieNode.geometry?.firstMaterial?.diffuse.contents = UIColor.lightGray
        
        return tieNode
    }
    
    fileprivate func setUpTunnels() -> SCNNode {
        let node = SCNNode()
        
        node.addChildNode(createTunnelNode(isLeft: true))
        node.addChildNode(createTunnelNode(isLeft: false))
        
        return node
    }
    
    func createTunnelNode(isLeft: Bool) -> SCNNode {
        let width: CGFloat = Constants.tileHeight - 0.05
        let radius: CGFloat = width / 2
        let straightHeight: CGFloat = 0.6
        
        let path = UIBezierPath()
        
        // Start at bottom left
        path.move(to: CGPoint(x: 0, y: 0))
        
        path.addLine(to: CGPoint(x: 0, y: straightHeight))
        
        for i in 0...20 {
            let x = (radius * 2) / 20 * CGFloat(i)
            let y = sqrt(pow(radius, 2) - pow(x - radius, 2)) + straightHeight
            
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        path.addLine(to: CGPoint(x: radius * 2, y: 0))
        
        path.addLine(to: CGPoint(x: 0, y: 0))
        
        path.close()
        
        let archShape = SCNShape(path: path, extrusionDepth: 0.01)
        
        archShape.firstMaterial?.diffuse.contents = UIColor.black
        
        let archNode = SCNNode(geometry: archShape)
        
        archNode.rotation = SCNVector4(x: 0, y: 1, z: 0, w: .pi / 2)
        
        // place on wall
        archNode.position = SCNVector3(isLeft ? Constants.totalWidth / 2 : -Constants.totalWidth / 2,
                                       0, radius)
        
        return archNode
    }
}
