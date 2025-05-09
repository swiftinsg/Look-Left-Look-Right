//
//  Server.swift
//  Look Left Look Right
//
//  Created by Jia Chen Yee on 5/4/25.
//

import SwiftUI
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
    
    var currentUser: ScanEntry?
    
    var isUserDead: Bool = false
    var isGameFinished: Bool = false

    var needsToResendGameLayoutInHeartbeat = true

    var leaderboard: [LeaderboardItem] = [
        LeaderboardItem(index: "ABC", name: "tristan", image: Data(), group: Group(session: .morning, groupNumber: 1), timing: 5),
        LeaderboardItem(index: "ABC", name: "tristan", image: Data(), group: Group(session: .morning, groupNumber: 1), timing: 5),
        LeaderboardItem(index: "ABC", name: "tristan", image: Data(), group: Group(session: .morning, groupNumber: 1), timing: 5),
        LeaderboardItem(index: "ABC", name: "tristan", image: Data(), group: Group(session: .morning, groupNumber: 1), timing: 5),
        LeaderboardItem(index: "ABC", name: "tristan", image: Data(), group: Group(session: .morning, groupNumber: 1), timing: 5),
        LeaderboardItem(index: "ABC", name: "tristan", image: Data(), group: Group(session: .morning, groupNumber: 1), timing: 5),
        LeaderboardItem(index: "ABC", name: "tristan", image: Data(), group: Group(session: .morning, groupNumber: 1), timing: 5),
        LeaderboardItem(index: "ABC", name: "tristan", image: Data(), group: Group(session: .morning, groupNumber: 1), timing: 5),
        LeaderboardItem(index: "ABC", name: "tristan", image: Data(), group: Group(session: .morning, groupNumber: 1), timing: 5),
        LeaderboardItem(index: "ABC", name: "tristan", image: Data(), group: Group(session: .morning, groupNumber: 1), timing: 5),
        LeaderboardItem(index: "ABC", name: "tristan", image: Data(), group: Group(session: .morning, groupNumber: 1), timing: 5),
        LeaderboardItem(index: "ABC", name: "tristan", image: Data(), group: Group(session: .morning, groupNumber: 1), timing: 5),
        LeaderboardItem(index: "ABC", name: "tristan", image: Data(), group: Group(session: .morning, groupNumber: 1), timing: 5)
    ]

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
        
        app.on(.GET, "hello") { req in
            if await self.needsToResendGameLayoutInHeartbeat {
                await MainActor.run {
                    self.needsToResendGameLayoutInHeartbeat = false
                }
                
                return await CameraHeartbeatResponse(gameLayout: self.gameLayout,
                                                     userFace: self.currentUser?.image,
                                                     isUserDead: self.isUserDead,
                                                     playerPosition: self.userCurrentTile)
            } else {
                return await CameraHeartbeatResponse(gameLayout: nil,
                                                     userFace: nil,
                                                     isUserDead: self.isUserDead,
                                                     playerPosition: self.userCurrentTile)
            }
        }
        
        try! await app.execute()
    }
    
    func updateTrainPositions() {
        Task {
            while true {
                try await Task.sleep(for: .seconds(0.015))
                
                var trainPosition: [Int: Double] = [:]
                
                for (index, tile) in gameLayout.tiles.enumerated() {
                    switch tile {
                    case .train(let train):
                        let position = train.position(for: gameLayout.gameStartTime, currentTime: .now) ?? 10
                        trainPosition[index] = position
                        
                        if train.inCrashRange(for: position) && userCurrentTile == index && !isUserDead {
                            // oopsie
                            isUserDead = true
                        }
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
        
        guard currentUser == nil else {
            return false
        }
        
        self.currentUser = scanEntry
        self.gameLayout = .random()
        self.isUserDead = false
        self.isGameFinished = false
        self.needsToResendGameLayoutInHeartbeat = true
        
        return true
    }

    func appendToLeaderboard(index: String, name: String, image: Data, group: Group, timing: Int) {
        let newItem = LeaderboardItem(
            index: index,
            name: name,
            image: image,
            group: group,
            timing: timing
        )

        if leaderboard.map({ $0.index }).contains(index) {
            if let index = leaderboard.firstIndex(where: { $0.index == index }) {
                leaderboard[index] = newItem
            }
        } else {
            leaderboard.append(newItem)
        }
        withAnimation {
            leaderboard = leaderboard.sorted(by: { $0.name < $1.name }).sorted(by: { $0.timing < $1.timing })
        }
    }
}
