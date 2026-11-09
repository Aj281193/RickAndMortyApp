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
    @Published var originalQuery: String = ""
    @Published var isCharacterLoading = true
    
    private var isLoading = false
    private var hasMore = true
    private var nextPageToken: String? = nil
    
    private let repository: CharacterRepositoryProtocol

    init(_ repository: CharacterRepositoryProtocol) {
        self.repository = repository
    }

    @MainActor
    func search(by query: String) async throws {
        // Normalize query (trim whitespace)
        let currentQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)

        // If query hasn't changed, do nothing
        guard currentQuery != originalQuery else { return }

        // Update query and reset pagination state
        originalQuery = currentQuery
        uiModelResult = []
        hasMore = true
        isCharacterLoading = true
        nextPageToken = nil

        // Kick off a fresh load for the first page with the new query
        do {
            try await loadNextPageIfNeeded()
        } catch {
            // On error, stop further pagination for this query
            hasMore = false
            isCharacterLoading = false
        }
    }

    func initialLoad() async throws {
        guard uiModelResult.isEmpty else {
            isCharacterLoading = false
            return
        }
        //initialize the feild for first time call
        hasMore = true
        originalQuery = ""
        isCharacterLoading = true
        
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
            let page = try await repository.fetchCharacters(pageToken: nextPageToken, name: originalQuery.isEmpty ? nil : originalQuery)
            let mapped = UIModel.map(from: page.results)

            await MainActor.run {
                self.uiModelResult.append(contentsOf: mapped)
                self.nextPageToken = page.info.nextToken
                self.hasMore = (self.nextPageToken != nil)
            }
        } catch {
            await MainActor.run {
                self.hasMore = false
                self.isCharacterLoading = false
            }
        }
    }
}

