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
    
    var userCurrentTile: Int? {
        floorTiles.filter { $0.gotHuman }.min {
            $0.date > $1.date
        }?.index
    }
    
    var trainPositions: [Int: Double] = [:]
    
    var gameLayout = GameLayout.random()
    
    var isGameIdle: Bool = true
    
    init() {
        floorTiles = (0..<9).map {
            Floor(index: $0, gotHuman: false, date: .distantPast)
        }
        
        updateTrainPositions()
    }
    
    func start() async {
        let app = try! await Application.make(.detect())
        
        app.http.server.configuration.hostname = "0.0.0.0"
        app.http.server.configuration.port = 8080
        
        app.on(.POST, "floor") { req in
            try await self.onFloorUpdateReceived(request: req)
            return "lgtm"
        }
        
        app.on(.GET, "ted") { req in
            return await self.gameLayout
        }
        
        app.on(.POST, "scan") { req in
            return try await self.onScanReceived(request: req) ? "hello alumni" : "goaway"
        }
        
        
        try! await app.execute()
    }
    
    func updateTrainPositions() {
        Task {
            while true {
                try await Task.sleep(for: .seconds(0.01))
                
                var trainPosition: [Int: Double] = [:]
                
                for (index, tile) in gameLayout.tiles.enumerated() {
                    switch tile {
                    case .train(let train):
                        trainPosition[index] = train.position(for: gameLayout.gameStartTime, currentTime: .now) ?? 10
                    default: continue
                    }
                }
                
                self.trainPositions = trainPosition
            }
        }
    }
    
    func onFloorUpdateReceived(request: Request) async throws {
        let message = try request.content.decode(Floor.self)
        
        await MainActor.run {
            self.floorTiles[message.index] = message
        }
    }
    
    func onScanReceived(request: Request) async throws -> Bool {
        let scanEntry = try request.content.decode(ScanEntry.self)
        
        guard isGameIdle else {
            return false
        }
        
        isGameIdle = false
        
        return true
    }
}
