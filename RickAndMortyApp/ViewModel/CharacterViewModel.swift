//
//  CharacterViewModel.swift
//  RickAndMortyApp
//
//  Created by Ashish Jaiswal on 30/10/26.
//

import SwiftUI
import Combine


final class CharacterViewModel: ObservableObject {
    @Published var uiModelResult: [UIModel] = []
    @Published var hasMorePublic: Bool = true

    private var isLoading = false
    private var hasMore = true
    private var nextPageURL: URL? = URL(string: "https://rickandmortyapi.com/api/character")

    private let repository: CharacterRepositoryProtocol

    init(_ repository: CharacterRepositoryProtocol) {
        self.repository = repository
    }

    func initialLoad() async throws {
        guard uiModelResult.isEmpty else { return }
        try await loadNextPageIfNeeded()
    }

    func loadMoreIfNeeded() async throws {
        try await loadNextPageIfNeeded()
    }

    private func loadNextPageIfNeeded() async throws {
        guard hasMore, !isLoading, let url = nextPageURL else { return }
        isLoading = true
        defer { isLoading = false }

        do {
            let page = try await repository.fetchCharacters(from: url)
            let mapped = UIModel.map(from: page.results)

            await MainActor.run {
                self.uiModelResult.append(contentsOf: mapped)
                if let nextStr = page.info.next, let nextURL = URL(string: nextStr) {
                    self.nextPageURL = nextURL
                    self.hasMore = true
                } else {
                    self.nextPageURL = nil
                    self.hasMore = false
                }
                self.hasMorePublic = self.hasMore
            }
        } catch {
            await MainActor.run {
                // stop or allow retry depending on your UX
                self.hasMore = false
                self.hasMorePublic = self.hasMore
            }
        }
    }
}
