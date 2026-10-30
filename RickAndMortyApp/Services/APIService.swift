import Foundation

protocol APIServiceProtocol: Sendable {
    func get<T: Decodable>(
        _ endpoint: String,
        as type: T.Type
    ) async throws -> T
}



// Usage:
enum APIError: Error {
    case invalidResponse
    case httpError(statusCode: Int)
    case decodingError(Error)
}

final actor APIService: APIServiceProtocol {
    private var baseURL: URL {
        URL(string: "https://rickandmortyapi.com/api")!
    }

    private let session: URLSession
    private let decoder: JSONDecoder

    init(session: URLSession = .shared,
         decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }

    nonisolated func get<T: Decodable>(
        _ endpoint: String,
        as type: T.Type
    ) async throws -> T {
        
        let url = await baseURL.appending(path: endpoint)
        let (data, response) = try await session.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw  APIError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw  APIError.httpError(
                statusCode: httpResponse.statusCode
            )
        }

        do {
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(T.self, from: data)
        } catch {
            throw  APIError.decodingError(error)
        }
    }
}

