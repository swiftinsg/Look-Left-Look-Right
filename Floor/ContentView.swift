//
//  ContentView.swift
//  Floor
//
//  Created by Jia Chen Yee on 5/4/25.
//

import SwiftUI

struct ContentView: View {

    @State private var client = Client()

    var body: some View {
        if !client.started {
            SetUpView()
                .environment(client)
        } else {
            ScannerView()
                .environment(client)
        }
    }
}

#Preview {
    ContentView()
}
