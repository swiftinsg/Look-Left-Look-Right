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
                if let currentUser = server.currentUser {
                    Image(nsImage: currentUser.toImage())
                        .resizable()
                        .scaledToFit()
                    Text("In memory of")
                        .font(.system(size: 150))
                        .fontWeight(.medium)
                    
                    Text("\(currentUser.name)")
                        .font(.system(size: 150))
                        .fontWeight(.bold)
                } else {
                    Text("You Died!")
                        .font(.system(size: 150))
                        .fontWeight(.bold)
                }
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
                LeaderboardDisplayView()
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

struct LeaderboardDisplayView: View {
    
    @Environment(Server.self) private var server
    
    var body: some View {
        VStack {
            HStack(alignment: .bottom) {
                if let user = server.leaderboard.safelyGet(index: 1) {
                    PodiumView(position: 1, image: Image(nsImage: user.nsImage),
                               name: user.name,
                               group: user.group.description,
                               timing: user.timing)
                }
                
                if let user = server.leaderboard.safelyGet(index: 0) {
                    PodiumView(position: 0, image: Image(nsImage: user.nsImage),
                               name: user.name,
                               group: user.group.description,
                               timing: user.timing)
                }
                
                if let user = server.leaderboard.safelyGet(index: 2) {
                    PodiumView(position: 2, image: Image(nsImage: user.nsImage),
                               name: user.name,
                               group: user.group.description,
                               timing: user.timing)
                }
            }
            Spacer()
            
            LazyHGrid(rows: [.init(), .init(), .init(), .init()]) {
                ForEach(3..<15) { index in
                    if let user = server.leaderboard.safelyGet(index: index) {
                        LeaderboardRowForPeopleWhoKindaSuckedButNotReallyThatMuchSoTheyAreStillOnScreenView(index: index, name: user.name, group: user.group.description, timing: user.timing)
                    }
                }
            }
            .padding()
        }
        .padding()
    }
}

struct LeaderboardRowForPeopleWhoKindaSuckedButNotReallyThatMuchSoTheyAreStillOnScreenView: View {
    
    var index: Int
    
    var name: String
    var group: String
    var timing: Int
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                Image(systemName: "\(index + 1).circle.fill")
                VStack(alignment: .leading) {
                    Text(name)
                        .fontWeight(.bold)
                    
                    HStack {
                        Text(group)
                        Spacer()
                        Text("\((timing - timing%60)/60)m \(timing%60)s")
                    }
                }
                Spacer()
            }
            .font(.system(size: 32))
            .padding(.vertical)
            .frame(width: 500, alignment: .leading)
            
            Rectangle()
                .frame(height: 1)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct PodiumView: View {
    
    var position: Int
    
    let heights: [Double] = [
        400, 300, 200
    ]
    
    let colors: [Color] = [
        .yellow, .gray, .brown
    ]
    
    var image: Image
    var name: String
    var group: String
    var timing: Int
    
    var body: some View {
        VStack {
            PhaseAnimator([Angle.degrees(-20), Angle.degrees(20)]) { angle in
                Image(.bryegg)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 150)
                    .shadow(color: colors[position], radius: 40, x: 0, y: 0)
                    .rotationEffect(angle, anchor: .bottom)
            }
            
            VStack {
                Text(name)
                    .font(.system(size: 64))
                    .fontWeight(.bold)
                
                Text("\((timing - timing%60)/60)m \(timing%60)s")
                    .font(.system(size: 32))
                
                Text("\(group)")
                    .font(.system(size: 32))
            }
            .padding()
            .frame(width: 500, height: heights[position], alignment: .top)
            .background(.white.opacity(0.1))
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
