//
//  Server.swift
//  Look Left Look Right
//
//  Created by Jia Chen Yee on 5/4/25.
//

import Foundation
import Observation
import Vapor

@Observable
@MainActor
final class Server: Sendable {
    var floorTiles: [Floor]
    
    init() {
        floorTiles = (0..<9).map {
            Floor(index: $0, gotHuman: false, date: .distantPast)
        }
    }
    
    func start() async {
        let app = try! await Application.make(.detect())
        
        app.http.server.configuration.hostname = "0.0.0.0"
        app.http.server.configuration.port = 8080
        
        app.on(.POST, "floor") { req in
            try await self.onFloorUpdateReceived(request: req)
            return "lgtm"
        }
        
        try! await app.execute()
    }
    
    func onFloorUpdateReceived(request: Request) async throws {
        let message = try request.content.decode(Floor.self)
        
        await MainActor.run {
            self.floorTiles[message.index] = message
        }
    }
}
