//
//  CameraHeartbeatResponse.swift
//  Look Left Look Right
//
//  Created by Jia Chen Yee on 5/9/25.
//

import Foundation

struct CameraHeartbeatResponse: Codable {
    var gameLayout: GameLayout?
    var userFace: Data?
    
    var isUserDead: Bool
    var playerPosition: Int?
    
    enum CodingKeys: String, CodingKey {
        case gameLayout = "g"
        case userFace = "f"
        case isUserDead = "d"
        case playerPosition = "p"
    }
}

#if canImport(Vapor)
import Vapor

extension CameraHeartbeatResponse: Content {}
#endif
