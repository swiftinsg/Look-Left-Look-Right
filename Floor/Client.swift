//
//  Client.swift
//  Floor
//
//  Created by Tristan Chay on 5/5/25.
//

import Foundation
import Observation

@Observable
class Client {
    var ip: String = ""
    var started: Bool = false

    var tileNumber: Int = 0
    var tileGotHuman: Bool = false

    var lastScannedDate = Date()

    func updateFloorState() async {
        guard !ip.isEmpty, let url = URL(string: "http://\(ip):8080/floor") else { return }

        let floor = Floor(index: tileNumber, gotHuman: tileGotHuman, date: Date())

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(floor)

        _ = try? await URLSession.shared.data(for: request)
    }
}
