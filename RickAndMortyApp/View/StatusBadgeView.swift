//
//  StatusBadgeView.swift
//  RickAndMortyApp
//
//  Created by Ashish Jaiswal on 31/10/26.
//

import SwiftUI

struct StatusBadgeView: View {
    let status: String
    
    var body: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(color(for: status))
                .frame(width: 8, height: 8)
            Text(status.capitalized)
                .font(.caption)
                .fontWeight(.semibold)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(
            Capsule()
                .fill(color(for: status).opacity(0.15))
        )
        .foregroundStyle(color(for: status))
    }
    
    private func color(for status: String) -> Color {
        switch status.lowercased() {
        case "alive": return .green
        case "dead": return .red
        default: return .gray
        }
    }
}
