import Foundation

protocol CharacterRepositoryProtocol: Sendable {
    func fetchCharacters(from url: URL) async throws -> CharactersModel
}


final class CharacterRepository: CharacterRepositoryProtocol {
  
    private let service: APIServiceProtocol
    
    init(service: APIServiceProtocol) {
        self.service = service
    }
    
    func fetchCharacters(from url: URL) async throws -> CharactersModel {
        return try await service.get(url, as: CharactersModel.self)
    }
    
}
