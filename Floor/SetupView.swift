//
//  SetUpView.swift
//  Floor
//
//  Created by Tristan Chay on 6/5/25.
//

import SwiftUI

struct SetUpView: View {

    @Environment(Client.self) private var client

    var body: some View {
        @Bindable var client = client

        NavigationStack {
            List {
                Section {
                    LabeledContent("IP Address") {
                        TextField(
                            "0.0.0.0",
                            text: Binding(get: {
                                client.ip
                            }, set: {
                                client.ip = $0
                            })
                        )
                        .monospaced()
                    }

                    Picker("Group", selection: $client.tileNumber) {
                        ForEach(0..<9, id: \.self) { i in
                            Text("Tile \(i)")
                                .tag(i)
                        }
                    }

                }

                DisclosureGroup("Developer Tools") {
                    Button("Prefill Loopback IP address") {
                        client.ip = "172.0.0.1"
                    }

                    Button("Prefill Tristan's hotspot address") {
                        client.ip = "172.20.10.5"
                    }
                }

                Button("Start") {
                    client.started = true
                }
                .disabled(client.ip.isEmpty)
            }
            .navigationTitle("Set Up Look Left Look Right Scanner")
        }
    }
}

#Preview {
    SetUpView()
}
