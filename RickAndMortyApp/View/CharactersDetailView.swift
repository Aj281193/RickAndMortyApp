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
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                KingfisherImageView(image: characterDetails.image, width: 350, height: 350)
                HStack {
                    Text(characterDetails.name)
                        .font(.headline)
                    Spacer()
                    Label("\(characterDetails.episode.count)", systemImage: "film")
                        .padding(.trailing, 10)
                }
                VStack(alignment: .leading) {
                    HStack {
                        StatusBadgeView(status: characterDetails.status)
                        ChipView(text: characterDetails.species)
                        ChipView(text: characterDetails.gender)
                        ChipView(text: characterDetails.location)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
            .navigationTitle("Character Details")
            .navigationBarTitleDisplayMode(.large)
            .background(Color.secondary.opacity(0.15).ignoresSafeArea()) 
        }
    }
}


#Preview {
    CharactersDetailView(characterDetails: UIModel(id: 1, name: "Rick", image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg", episode: ["1","2","3"], status: "alive", species: "Alien", gender: "Male", location: "Torando"))
}
