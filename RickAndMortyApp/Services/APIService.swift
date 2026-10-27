import Foundation

protocol APIServiceProtocol: Sendable {
    func get<T: Decodable & Sendable>(
        _ endpoint: String,
        as type: T.Type
    ) async throws -> T
}

enum APIError: Error {
    case invalidResponse
    case httpError(statusCode: Int)
    case decodingError(Error)
}

final class APIService: APIServiceProtocol {

    private let baseURL: URL
    private let session: URLSession
    private let decoder: JSONDecoder

    init(
        baseURL: URL,
        session: URLSession = .shared,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.baseURL = baseURL
        self.session = session
        self.decoder = decoder
    }

    func get<T: Decodable & Sendable>(
        _ endpoint: String,
        as type: T.Type
    ) async throws -> T {
        
        let url = baseURL.appending(path: endpoint)
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
            return try decoder.decode(T.self, from: data)
        } catch {
            throw  APIError.decodingError(error)
        }
    }
}

