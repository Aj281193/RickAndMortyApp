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
            CharactersListView()
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
    
    private func CharactersListView() -> some View {
        return List(viewModel.uiModelResult, id: \.id) { item in
            CharacterRow(item: item)
                .onAppear {
                    Task {
                        try? await viewModel.loadMoreIfNeeded()
                    }
                }
        }
        .listStyle(.insetGrouped)
    }
}
#Preview {
    CharactersView()
}

