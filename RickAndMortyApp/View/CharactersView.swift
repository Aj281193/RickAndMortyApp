//
//  ContentView.swift
//  RickAndMortyApp
//
//  Created by Ashish Jaiswal on 26/10/26.
//

import SwiftUI

struct CharactersView: View {
    
    @StateObject private var viewModel: CharacterViewModel
    
    init() {
        let service = APIService()
        let repository = CharacterRepository(service: service)
        self._viewModel = StateObject(wrappedValue: CharacterViewModel(repository))
    }
    
    var body: some View {
        NavigationStack {
            List(viewModel.uiModelResult, id: \.id) { item in
                HStack {
                    HStack(spacing: 8) {
                        KingfisherImageView(image: item.image)
                        VStack(alignment: .leading) {
                            Text(item.name.prefix(20))
                                .font(.headline)
                            Text("Episodes: \(item.episode.count)")
                                .font(.subheadline)
                        }
                    }
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                                            .font(.system(.footnote, design: .default).weight(.semibold))
                                            .foregroundColor(Color(UIColor.tertiaryLabel))
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Characters")
            .background(Color.secondary.opacity(0.15).ignoresSafeArea()) 
        }
        .task {
            do {
                try await viewModel.getCharacters()
            } catch {
                print("Failed to load characters: \(error)")
            }
        }
    }
}

#Preview {
    //here need to add preview so that without running code we can able to see
    CharactersView()
}
