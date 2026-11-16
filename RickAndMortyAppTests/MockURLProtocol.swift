import Foundation


final class MockURLProtocol: URLProtocol {
    // MARK: - Per-test token-based state
    // We avoid global races by allowing tests to register handlers keyed by a token.
    private static var handlersByToken: [String: (URLRequest) throws -> (HTTPURLResponse, Data)] = [:]
    private static var errorsByToken: [String: Error?] = [:]
    private static let stateQueue = DispatchQueue(label: "MockURLProtocol.state", attributes: .concurrent)

    // Legacy global fallback to match existing tests that reference .requestHandler and .error
    // These are kept for compatibility but should be avoided in favor of tokens when running in parallel.
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
    static var error: Error?

    // MARK: - Registration API
    static func set(handler: @escaping (URLRequest) throws -> (HTTPURLResponse, Data), error: Error? = nil, for token: String) {
        stateQueue.async(flags: .barrier) {
            handlersByToken[token] = handler
            errorsByToken[token] = error
        }
    }

    static func clear(token: String) {
        stateQueue.async(flags: .barrier) {
            handlersByToken[token] = nil
            errorsByToken[token] = nil
        }
    }

    // MARK: - URLProtocol overrides
    override class func canInit(with request: URLRequest) -> Bool {
        // Intercept all requests; the session's configuration controls usage of this protocol.
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        // Try to resolve by token first, falling back to global handler for backwards compatibility.
        let token = self.request.value(forHTTPHeaderField: "X-Mock-Token")

        // Resolve error and handler safely
        let resolved: (handler: ((URLRequest) throws -> (HTTPURLResponse, Data))?, error: Error?) = {
            if let token = token {
                var h: ((URLRequest) throws -> (HTTPURLResponse, Data))?
                var e: Error?
                MockURLProtocol.stateQueue.sync {
                    h = MockURLProtocol.handlersByToken[token]
                    e = MockURLProtocol.errorsByToken[token] ?? nil
                }
                return (h, e)
            } else {
                return (MockURLProtocol.requestHandler, MockURLProtocol.error)
            }
        }()

        if let error = resolved.error {
            client?.urlProtocol(self, didFailWithError: error)
            return
        }

        guard let handler = resolved.handler else {
            // No handler configured; fail fast to avoid timeouts.
            let err = URLError(.unsupportedURL)
            client?.urlProtocol(self, didFailWithError: err)
            return
        }

        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() {
        // Nothing to clean up for synchronous mocks
    }
}

