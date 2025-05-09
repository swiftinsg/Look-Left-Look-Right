//
//  SessionSetUpTesterView.swift
//  Look Left Look Right
//
//  Created by Jia Chen Yee on 5/9/25.
//

import SwiftUI
import AppKit

struct SessionSetUpTesterView: View {
    
    @Environment(Server.self) var server
    @State private var name = ""
    @State private var index = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            if let currentUser = server.currentUser {
                LabeledContent("name", value: currentUser.name)
                LabeledContent("index", value: currentUser.index)
                LabeledContent("date", value: currentUser.date.formatted())
            }
            
            Divider()
            
            Text("overwrite settings")
                .font(.title2)
                .fontWeight(.bold)
            TextField("Name", text: $name)
            TextField("Index", text: $index)
            
            Button("start game and run config") {
                Task {
                    server.currentUser = ScanEntry(date: .now, id: UUID().uuidString, index: index, name: name, image: try! await Image(.bryegg).exported(as: .png))
                    server.gameLayout = .random()
                    server.isUserDead = false
                    server.isGameFinished = false
                    server.needsToResendGameLayoutInHeartbeat = true
                    
                    name = ""
                    index = ""
                }
            }
        }
    }
}

#Preview {
    SessionSetUpTesterView()
}
