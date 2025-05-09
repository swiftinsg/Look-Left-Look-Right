//
//  LeaderboardView.swift
//  Look Left Look Right
//
//  Created by Tristan Chay on 9/5/25.
//

import SwiftUI

struct LeaderboardView: View {

    let rows = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    @Environment(Server.self) private var server

    var body: some View {
        VStack {
            if server.isUserDead {
                Text("You Died!")
                    .font(.system(size: 150))
                    .fontWeight(.bold)
            } else if let currentUser = server.currentUser, server.isGameFinished {
                Text("Congrats, \(currentUser.name)!")
                    .font(.system(size: 150))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .onAppear {
                        server.appendToLeaderboard(
                            index: currentUser.index,
                            name: currentUser.name,
                            image: currentUser.image,
                            group: currentUser.group,
                            timing: abs(Int(server.gameLayout.gameStartTime.timeIntervalSinceNow))
                        )
                    }
            } else {
                VStack {
                    LeaderboardPodium(
                        position: 1,
                        name: "",
                        timing: <#T##Int#>,
                        data: <#T##Data#>,
                        group: <#T##Group#>
                    )
                }
            }
        }
        .frame(width: 1920, height: 1080)
        .background(server.isGameFinished ? .green : server.isUserDead ? .red : .black)
        .onChange(of: server.userCurrentTile) {
            if server.userCurrentTile == 8 {
                server.isGameFinished = true
            }
        }
    }
}

struct LeaderboardRow: View {

    var position: Int
    var name: String
    var timing: Int

    var body: some View {
        HStack(spacing: 0) {
            Text("\(position). ")
            Text(name).fontWeight(.bold)
            Text(" \((timing - timing%60)/60)m \(timing%60)s")
        }
        .font(.system(size: 40))
    }
}

struct LeaderboardPodium: View {

    var position: Int
    var name: String
    var timing: Int
    var data: Data
    var group: Group

    var body: some View {
        VStack {
            Image(nsImage: NSImage(data: data) ?? NSImage())
            Text(name).fontWeight(.bold)
            Text("\(timing) \(group.description)")
        }
    }
}

#Preview {
    LeaderboardView()
}
