//
//  ScannerView.swift
//  Floor
//
//  Created by Tristan Chay on 5/5/25.
//

import SwiftUI
import CodeScanner

struct ScannerView: View {

    @Environment(Client.self) private var client

    var body: some View {
        CodeScannerView(codeTypes: [.qr], scanMode: .continuous, scanInterval: 0.1, simulatedData: "https://swiftin.sg/crossy0") { response in
            switch response {
            case .success(let result):
                if let tileNumber = Int(
                    result.string.replacingOccurrences(
                        of: "https://swiftin.sg/crossy",
                        with: ""
                    )
                ) {
                    if tileNumber == client.tileNumber {
                        client.lastScannedDate = Date()
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        .ignoresSafeArea()
        .onChange(of: client.tileGotHuman) {
            let client = client
            Task {
                await client.updateFloorState()
            }
        }
        .onAppear {
            startTimer()
        }
    }

    func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            Task { @MainActor in
                let timeSinceLastScan = Date().timeIntervalSince(client.lastScannedDate)
                let gotHuman = timeSinceLastScan > 0.3

                client.tileGotHuman = gotHuman
            }
        }
    }
}

#Preview {
    ScannerView()
}
