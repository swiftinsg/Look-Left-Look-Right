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
    
    var ipAddress = "192.168.18.193"
    
    var userFace: UIImage?
    
    var playerPosition: Int?
    
    var isUserDead = false
    
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
                
                playerPosition = result.playerPosition
                
                isUserDead = result.isUserDead
                
                print("❤️ \(result)")
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
