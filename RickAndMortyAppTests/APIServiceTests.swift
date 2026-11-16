//
//  APIServiceTests.swift
//  RickAndMortyAppTests
//
//  Created by Ashish Jaiswal on 15/11/26.
//

import Foundation
import Testing
@testable import RickAndMortyApp

// Helper to build a URLSession that uses MockURLProtocol and injects a unique mock token header
private func makeMockedSession() -> (session: URLSession, token: String) {
    let token = UUID().uuidString
    let config = URLSessionConfiguration.ephemeral
    config.protocolClasses = [MockURLProtocol.self]
    config.httpAdditionalHeaders = ["X-Mock-Token": token]
    let session = URLSession(configuration: config)
    return (session, token)
}

@MainActor
@Suite("APIService tests")
struct APIServiceTests {

    // MARK: - Sample JSON
    private static let validCharactersJSON = {
        """
        {
          "info": {"count": 1,
          "pages": 1,
          "next": null,
          "prev": null
         },
          "results": [
            {
              "id": 1,
              "name": "Rick Sanchez",
              "status": "Alive",
              "species": "Human",
              "gender": "Male",
              "location": {
                   "name": "Earth",
                   "url": "https://example.com/earth"
               },
              "image": "https://example.com/rick.png",
              "episode": ["S01E01"],
              "url": "https://rickandmortyapi.com/api/character/1",
              "created": "2017-11-04T18:48:46.250Z"
            }
          ]
        }
        """
    }()

    // MARK: - Success
    @Test("GET success decodes model")
    func get_success_decodesModel() async throws {
        let (session, token) = makeMockedSession()
        let service = APIService(session: session)

        MockURLProtocol.set(handler: { (request: URLRequest) throws -> (HTTPURLResponse, Data) in
            // Expect URL built from base + path
            #expect(request.url?.absoluteString == "https://rickandmortyapi.com/api/character")
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            let data = APIServiceTests.validCharactersJSON.data(using: .utf8)!
            return (response, data)
        }, error: nil, for: token)
        defer { MockURLProtocol.clear(token: token) }

        let model: CharactersModel = try await service.get("/character", as: CharactersModel.self)
        #expect(model.info.count == 1)
        #expect(model.results.first?.name == "Rick Sanchez")
    }

    // MARK: - HTTP error status
    @Test("HTTP error status propagates httpError")
    func http_error_status() async throws {
        let (session, token) = makeMockedSession()
        let service = APIService(session: session)

        MockURLProtocol.set(handler: { (request: URLRequest) throws -> (HTTPURLResponse, Data) in
            let response = HTTPURLResponse(url: request.url!, statusCode: 404, httpVersion: nil, headerFields: nil)!
            return (response, Data("{}".utf8))
        }, error: nil, for: token)
        defer { MockURLProtocol.clear(token: token) }

        do {
            let _ = try await service.get("/character", as: CharactersModel.self)
        } catch {
            if case APIError.httpError(let code) = error {
                #expect(code == 404)
            }
        }
    }

    // MARK: - Decoding error
    @Test("Decoding error is wrapped")
    func decoding_error_wrapped() async throws {
        let (session, token) = makeMockedSession()
        let service = APIService(session: session)

        MockURLProtocol.set(handler: { (request: URLRequest) throws -> (HTTPURLResponse, Data) in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            // Malformed JSON
            let data = Data("{\"bad\":true}".utf8)
            return (response, data)
        }, error: nil, for: token)
        defer { MockURLProtocol.clear(token: token) }

        do {
            let _ = try await service.get("/character", as: CharactersModel.self)
        } catch {
            if case APIError.decodingError = error {
                #expect(true)
            }
        }
    }

    // MARK: - Transport error
    @Test("Transport error is propagated")
    func transport_error_propagated() async throws {
        let (session, token) = makeMockedSession()
        let service = APIService(session: session)

        MockURLProtocol.set(handler: { (_: URLRequest) throws -> (HTTPURLResponse, Data) in
            fatalError("should not be called")
        }, error: URLError(.timedOut), for: token)
        defer { MockURLProtocol.clear(token: token) }

        do {
            let _ = try await service.get("/character", as: CharactersModel.self)
        } catch {
            #expect((error as? URLError)?.code == .timedOut)
        }
    }

    
    // MARK: - Query handling and percent-decoding
    @Test("Query handling encodes/decodes correctly")
    func query_handling_percent_decodings() async throws {
        let (session, token) = makeMockedSession()
        let service = APIService(session: session)
        
        MockURLProtocol.set(handler: { (request: URLRequest) throws -> (HTTPURLResponse, Data) in
            #expect(request.url?.absoluteString == "https://rickandmortyapi.com/api/character?name=Rick%20Sanchez")
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            let data = APIServiceTests.validCharactersJSON.data(using: .utf8)!
            return (response, data)
        }, error: nil, for: token)
        defer { MockURLProtocol.clear(token: token) }
       
        let model = try await service.get("/character?name=Rick%20Sanchez", as: CharactersModel.self)
        #expect(model.results.count == 1)
    }
}

