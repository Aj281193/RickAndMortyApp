import Foundation

protocol CharacterRepositoryProtocol {
    func fetchCharacters(pageToken: String?, name: String?) async throws -> CharactersModel
}

final class CharacterRepository: CharacterRepositoryProtocol {
  
    private let service: APIServiceProtocol
    
    init(service: APIServiceProtocol) {
        self.service = service
    }
    

    func fetchCharacters(pageToken: String?, name: String?) async throws -> CharactersModel {
        var components: [String] = []
        if let pageToken, !pageToken.isEmpty {
            components.append("page=\(pageToken)")
        }
        if let name, !name.isEmpty {
            let encodedName = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? name
            components.append("name=\(encodedName)")
        }
        let query = components.isEmpty ? "" : "?" + components.joined(separator: "&")
        let path = "/character\(query)"
        return try await service.get(path, as: CharactersModel.self)
    }
}
