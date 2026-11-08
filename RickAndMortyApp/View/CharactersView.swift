//
//  ContentView.swift
//  RickAndMortyApp
//
//  Created by Ashish Jaiswal on 26/10/26.
//

import SwiftUI

struct CharactersView: View {
    
    @StateObject private var viewModel: CharacterViewModel
    @State private var searchDebounceTask: Task<Void, Never>? = nil
    @State private var searchText = ""
    
    init() {
        let service = APIService()
        let repository = CharacterRepository(service: service)
        self._viewModel = StateObject(wrappedValue: CharacterViewModel(repository))
    }
    
    var body: some View {
        NavigationStack {
            CharactersListView()
            .searchable(text: $searchText, prompt: "Search characters by name")
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
            .onChange(of: searchText) { _, newValue in
                //cancel the running task
                searchDebounceTask?.cancel()
                //start the fresh task
                searchDebounceTask = Task {
                    do {
                        try await Task.sleep(nanoseconds: 300_000_000)
                        guard !Task.isCancelled else { return }
                        try await viewModel.search(by: newValue)
                    } catch {
                        if (error as? CancellationError) == nil {
                            print("Search task failed: \(error)")
                        }
                    }
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
