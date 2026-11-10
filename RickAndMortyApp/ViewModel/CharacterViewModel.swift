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
    @Published var didInitialLoadFail = false
    @Published var isSearching = false
    
    private var hasMore = true
    private var nextPageToken: String? = nil
    private var searchDebounceTask: Task<Void, Never>? = nil
    
    private let repository: CharacterRepositoryProtocol

    init(_ repository: CharacterRepositoryProtocol) {
        self.repository = repository
    }

    @MainActor
    func search(by query: String) async throws {
        isSearching = false
        
        //cancel the running task
        searchDebounceTask?.cancel()
        //start the fresh task
        searchDebounceTask = Task {
            
            try? await Task.sleep(nanoseconds: 300_000_000)
            
            if Task.isCancelled {
                isSearching = false
                return
            }
            // Normalize query (trim whitespace)
            let currentQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // If query hasn't changed, do nothing
            guard currentQuery != originalQuery else { return }
            
            // Update query and reset pagination state
            originalQuery = currentQuery
            isSearching = !originalQuery.isEmpty
            uiModelResult = []
            hasMore = true
            nextPageToken = nil
            
            // Kick off a fresh load for the first page with the new query
            do {
                try await loadNextPageIfNeeded()
            } catch {
                hasMore = false
                isSearching = false
            }
        }
    }

    func initialLoad() async throws {
        didInitialLoadFail = false
        guard uiModelResult.isEmpty else {
            didInitialLoadFail = false
            return
        }
        //initialize the feild for first time call
        hasMore = true
        originalQuery = ""
        
        try await loadNextPageIfNeeded()
    }

    func loadNextPageIfNeeded() async throws {
        guard hasMore else { return }

        do {
            let page = try await repository.fetchCharacters(pageToken: nextPageToken, name: originalQuery.isEmpty ? nil : originalQuery)
            let mapped = UIModel.map(from: page.results)

            await MainActor.run {
                self.uiModelResult.append(contentsOf: mapped)
                self.nextPageToken = page.info.nextToken
                self.hasMore = (self.nextPageToken != nil)
                self.isSearching = false
            }
        } catch {
            await MainActor.run {
                self.hasMore = false
                self.isSearching = false
                if self.originalQuery.isEmpty { self.didInitialLoadFail = true }
            }
        }
    }
}

