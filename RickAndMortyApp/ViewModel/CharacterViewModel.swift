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
    
    private let repository: CharacterRepositoryProtocol
    
    init(_ repository: CharacterRepositoryProtocol) {
        self.repository = repository
    }
    
    func getCharacters() async throws {
        let characters = try await repository.fetchCharacters()
        await MainActor.run {
            self.uiModelResult = UIModel.map(from: characters)
        }
    }
}

