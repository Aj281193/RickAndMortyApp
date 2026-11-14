//
//  CharactersDetailView.swift
//  RickAndMortyApp
//
//  Created by Ashish Jaiswal on 27/10/26.
//

import SwiftUI

struct CharactersDetailView: View {
    
    private let characterDetails: UIModel
    
    init(characterDetails: UIModel) {
        self.characterDetails = characterDetails
    }
     
    var body: some View {
            VStack(alignment: .leading, spacing: 20) {
                KingfisherImageView(
                    image: characterDetails.image,
                    width: 350,
                    height: 350
                )
                .aspectRatio(1.5, contentMode: .fill)
                HStack {
                    Text(characterDetails.name)
                    .font(.headline)
                    Spacer()
                    HStack(spacing: 12) {
                        Label("\(characterDetails.episode.count)", systemImage: "film.fill")
                            .foregroundStyle(.secondary)
                            .padding(.trailing, 10)
                    }
                }
                .accessibilityLabel(Text(verbatim: "\(characterDetails.name), Episodes: \(characterDetails.episode.count)"))
                .accessibilityHint(Text(verbatim: "Shows character details"))
                VStack(alignment: .leading) {
                    HStack(spacing: 20) {
                        StatusBadgeView(status: characterDetails.status)
                            .accessibilityLabel(Text(verbatim: "\(characterDetails.status)"))
                        ChipView(text: characterDetails.species)
                            .accessibilityLabel(Text(verbatim: "\(characterDetails.species)"))
                        ChipView(text: characterDetails.gender)
                            .accessibilityLabel(Text(verbatim: "\(characterDetails.gender)"))
                        ChipView(text: characterDetails.location)
                            .accessibilityLabel(Text(verbatim: "\(characterDetails.location)"))
                    }.frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
            .navigationTitle("Character Details")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color.secondary.opacity(0.15).ignoresSafeArea())
    }
}


#Preview {
    CharactersDetailView(characterDetails: UIModel(id: 1, name: "Rick", image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg", episode: ["1","2","3"], status: "alive", species: "Alien", gender: "Male", location: "Torando"))
}
