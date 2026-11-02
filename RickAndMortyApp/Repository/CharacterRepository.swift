import Foundation


protocol CharacterRepositoryProtocol {
    func fetchCharacters(pageToken: String?) async throws -> CharactersModel
}

final class CharacterRepository: CharacterRepositoryProtocol {
  
    private let service: APIServiceProtocol
    
    init(service: APIServiceProtocol) {
        self.service = service
    }
    
    
    func fetchCharacters(pageToken: String?) async throws -> CharactersModel {
        if let pageToken {
            return try await service.get("/character/?page=\(pageToken)", as: CharactersModel.self)
        } else{
            return try await service.get("/character", as: CharactersModel.self)
        }
    }
    
}
