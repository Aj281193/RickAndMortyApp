import Foundation

protocol APIServiceProtocol: Sendable {
    func get<T: Decodable>(
        _ url: URL,
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
    private let session: URLSession
    private let decoder: JSONDecoder

    init(session: URLSession = .shared,
         decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }

    nonisolated func get<T: Decodable>(
        _ url: URL,
        as type: T.Type
    ) async throws -> T {
        
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

