//
//  ChipView.swift
//  RickAndMortyApp
//
//  Created by Ashish Jaiswal on 31/10/26.
//

import SwiftUI

struct ChipView: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.caption)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Capsule()
                .fill(Color.secondary.opacity(0.05)))
            .foregroundStyle(.secondary)
            .lineLimit(1)
    }
}
