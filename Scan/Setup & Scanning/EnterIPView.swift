//
//  EnterIPView.swift
//  Scan
//
//  Created by Sean on 5/5/25.
//

import SwiftUI

struct EnterIPView: View {
    @Binding var ip: String
    @State var ipInput: String = ""
    var body: some View {
        VStack {
            TextField("Enter the IP here", text: $ipInput)
                .padding()
            Button("Connect") {
                ip = ipInput
            }
            .disabled(!ipInput.isValidIpAddress)
            .padding()
            .buttonStyle(.borderedProminent)

            Button("prefill w/ sean ip") {
                ipInput = "192.168.1.12"
            }
        }
        
    }
    
    
}

extension String {
    
    /// Property tells whether a string is a valid IP or not
    var isValidIpAddress: Bool {
        let validIpAddressRegex = "^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$"
        let predicate = NSPredicate.init(format: "SELF MATCHES %@", validIpAddressRegex)
        let matches = predicate.evaluate(with: self)
        return matches
    }
    
}
