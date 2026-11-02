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
    
    private var isLoading = false
    private var hasMore = true
    private var nextPageToken: String? = nil
    
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
        guard hasMore, !isLoading else { return }
        isLoading = true
        defer { isLoading = false }

        do {
            let page = try await repository.fetchCharacters(pageToken: nextPageToken)
            let mapped = UIModel.map(from: page.results)

            await MainActor.run {
                self.uiModelResult.append(contentsOf: mapped)
                self.nextPageToken = page.info.nextToken
                self.hasMore = (self.nextPageToken != nil)
            }
        } catch {
            await MainActor.run {
                self.hasMore = false
            }
        }
    }
}
