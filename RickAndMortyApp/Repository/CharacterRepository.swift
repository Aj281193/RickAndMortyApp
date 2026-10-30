protocol CharacterRepositoryProtocol: Sendable {
    func fetchCharacters() async throws -> [CharactersResponseResult]
}


final class CharacterRepository: CharacterRepositoryProtocol {
    
    private let service: APIServiceProtocol
    
    init(service: APIServiceProtocol) {
        self.service = service
    }
    
    func fetchCharacters() async throws -> [CharactersResponseResult] {
        let response = try await service.get("/character", as: CharactersModel.self)
        return response.results
    }
}
