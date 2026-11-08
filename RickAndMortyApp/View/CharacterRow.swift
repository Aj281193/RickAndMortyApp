//
//  CharacterRow.swift
//  RickAndMortyApp
//
//  Created by Ashish Jaiswal on 04/11/26.
//

import SwiftUI

struct CharacterRow: View {
    private let item: UIModel
    
    init(item: UIModel) {
        self.item = item
    }
    
    var body: some View {
        NavigationLink(value: item) {
            HStack(spacing: 8) {
                KingfisherImageView(image: item.image)
                VStack(alignment: .leading) {
                    Text(item.name.prefix(20))
                        .font(.headline)
                    Text("Episodes: \(item.episode.count)")
                        .font(.subheadline)
                }
            }
            .accessibilityLabel(Text(verbatim: "\(item.name)"))
        }
    }
}
