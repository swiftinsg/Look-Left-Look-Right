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
    var trainTrackNodes: [Int: SCNNode] = [:]
    
    var ipAddress = "192.168.18.193"
    
    var userFace: UIImage?
    
    var playerPosition: Int?
    
    var transparencyNodes: [Int: [SCNNode]] = [:]
    
    var isUserDead = false
    var deathMessage = "L BOZO"
    
    func startHeartbeatMessages() async {
        while true {
            var request = URLRequest(url: URL(string: "http://\(ipAddress):8080/hello")!)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            do {
                let (data, _) = try await URLSession.shared.data(for: request)
                
                let result = try! JSONDecoder().decode(CameraHeartbeatResponse.self, from: data)
                
                if let gameLayout = result.gameLayout {
                    setUpLayout(gameLayout)
                }
                
                if let userFace = result.userFace {
                    self.userFace = UIImage(data: userFace)
                }
                
                updateNodeAlpha(newPlayerPosition: result.playerPosition)
                
                updateDeathState(newDeathState: result.isUserDead)

            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func updateDeathState(newDeathState: Bool) {
        guard isUserDead != newDeathState else { return }
        
        if newDeathState {
            deathMessage = [
                "L BOZO",
                "unfortunate.",
                "L",
                "too bad.",
                "you suck",
                "skill issue",
                "get pancaked",
                "oh."
            ].randomElement()!
            
            if let playerPosition {
                createTrackSplatter(at: playerPosition)
            }
        }
        
        isUserDead = newDeathState
    }
    
    func updateNodeAlpha(newPlayerPosition: Int?) {
        guard playerPosition != newPlayerPosition else { return }
        
        if let newPlayerPosition {
            for (key, value) in transparencyNodes {
                
                let transparency = key < newPlayerPosition ? 0.3 : 1
                
                for node in value {
                    node.opacity = transparency
                }
            }
        }
        
        playerPosition = newPlayerPosition
    }
}
