//
//  TreeView.swift
//  Look Left Look Right
//
//  Created by Jia Chen Yee on 5/5/25.
//

import SwiftUI

struct TreeView: View {
    var body: some View {
        Image(systemName: "tree.fill")
            .font(.largeTitle)
            .padding()
            .frame(maxHeight: .infinity)
            .background(.black.opacity(0.2))
            .clipShape(.rect(cornerRadius: 16))
            .padding()
            .foregroundStyle(.black)
    }
}

#Preview {
    TreeView()
}
