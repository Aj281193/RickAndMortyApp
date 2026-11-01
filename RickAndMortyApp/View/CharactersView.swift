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
                CharacterRow(item: item)
                    .onAppear {
                        Task {
                            try? await viewModel.loadMoreIfNeeded()
                        }
                    }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Characters")
            .navigationDestination(for: UIModel.self) { selectedItem in
                CharactersDetailView(characterDetails: selectedItem)
            }
            .background(Color.secondary.opacity(0.15).ignoresSafeArea())
            .task {
                do {
                    try await viewModel.initialLoad()
                } catch {
                    print("Failed to load characters: \(error)")
                }
            }
        }
    }
}
#Preview {
    CharactersView()
}

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
        }
    }
}

