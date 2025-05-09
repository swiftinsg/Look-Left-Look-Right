//
//  LookLeftLookRightApp.swift
//  Look Left Look Right
//
//  Created by Jia Chen Yee on 5/4/25.
//

import SwiftUI

@main
struct LookLeftLookRightApp: App {

    @State private var server = Server()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(server)
        }
        WindowGroup(id: "leaderboard") {
            LeaderboardView()
                .environment(server)
        }
    }
}
