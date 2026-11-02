import Foundation

protocol APIServiceProtocol: Sendable {
    func get<T: Decodable>(
        _ endpoint: String,
        as type: T.Type
    ) async throws -> T
}



// Usage:
enum APIError: Error {
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int)
    case decodingError(Error)
}

enum APIEndPoint: String {
    case  baseURL = "https://rickandmortyapi.com/api"
}

final actor APIService: APIServiceProtocol {
    private let session: URLSession
    private let decoder: JSONDecoder

    init(session: URLSession = .shared,
         decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        self.decoder = decoder
    }

    nonisolated func get<T: Decodable>(
        _ endpoint: String,
        as type: T.Type
    ) async throws -> T {
        
           guard let baseURL = URL(string: APIEndPoint.baseURL.rawValue) else {
               throw APIError.invalidURL
           }
           
           var finalURL: URL = baseURL.appending(path: endpoint)
        
          // Safely resolve percent-encoding issues (like %3F replacing '?')
           if let decodedString = finalURL.absoluteString.removingPercentEncoding,
              let correctedURL = URL(string: decodedString) {
               finalURL = correctedURL
           }
        
           let (data, response) = try await session.data(from: finalURL)
           
           guard let httpResponse = response as? HTTPURLResponse else {
               throw APIError.invalidResponse
           }

           guard (200...299).contains(httpResponse.statusCode) else {
               throw APIError.httpError(statusCode: httpResponse.statusCode)
           }
        
           do {
               return try decoder.decode(T.self, from: data)
           } catch {
               throw APIError.decodingError(error)
           }
        
    }
}

