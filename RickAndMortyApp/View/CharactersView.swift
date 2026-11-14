//
//  ContentView.swift
//  RickAndMortyApp
//
//  Created by Ashish Jaiswal on 26/10/26.
//

import SwiftUI

struct CharactersView: View {
    
    @StateObject private var viewModel: CharacterViewModel
    @State private var searchText = ""
    
    init() {
        let service = APIService()
        let repository = CharacterRepository(service: service)
        self._viewModel = StateObject(wrappedValue: CharacterViewModel(repository))
    }
    
    var body: some View {
        NavigationStack {
            if viewModel.didInitialLoadFail {
                ContentUnavailableView(
                    "Characters Loading failed",
                    systemImage: "exclamationmark.triangle.fill",
                    description: Text("contentUnavailable")
                )
                .symbolRenderingMode(.multicolor)
                .safeAreaInset(edge: .bottom) {
                    Button(action: {
                        Task {
                            try await viewModel.initialLoad()
                        }
                    }) {
                        Label("Retry Loading", systemImage: "arrow.clockwise")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.accentColor)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 16)
                }
            } else {
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
                        Task {
                            try await viewModel.search(by: newValue)
                        }
                    }.overlay {
                        if !viewModel.isSearching && viewModel.uiModelResult.isEmpty && !searchText.isEmpty {
                            ContentUnavailableView(
                                "Please enter valid character Name",
                                systemImage: "person.fill.questionmark",
                                description: Text("We couldn't find any characters matching '\(searchText)'")
                            )
                        }
                    }
            }
        }
    }
    
    private func CharactersListView() -> some View {
        List {
            Section {
                ForEach(viewModel.uiModelResult, id: \.id) { item in
                    CharacterRow(item: item)
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(Color(.secondarySystemBackground))
                                .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 2)
                        )
                        .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                        .onAppear {
                            Task { try? await viewModel.loadNextPageIfNeeded() }
                        }
                }
            } header: {
                Color.clear
                    .frame(height: 8)
                    .listRowInsets(EdgeInsets())
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(Color.secondary.opacity(0.15))
    }
}
#Preview {
    CharactersView()
}
