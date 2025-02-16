import Foundation

// MARK: - NetworkingService
protocol NetworkingServiceProtocol: Sendable {
    func send(request: NetworkRequest) async throws -> Data
    func send<T: Decodable>(request: NetworkRequest, type: T.Type) async throws -> T
}

// MARK: - DefaultNetworkingService
struct DefaultNetworkingService: NetworkingServiceProtocol {

    // MARK: - Dependencies
    private let session: URLSession
    private let decoder: JSONDecoder
    private let encode: JSONEncoder

    // MARK: - Initializer
    init(
        session: URLSession = URLSession.shared,
        decoder: JSONDecoder = JSONDecoder(),
        encode: JSONEncoder = JSONEncoder()
    ) {
        self.session = session
        self.decoder = decoder
        self.encode = encode
    }

    // MARK: - Public methods
    func send(request: any NetworkRequest) async throws -> Data {
        guard let urlRequest = createRequest(request: request) else {
            throw NetworkingServiceError.urlSessionError
        }

        let (data, response) = try await session.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkingServiceError.urlSessionError
        }

        guard 200..<300 ~= httpResponse.statusCode else {
            throw NetworkingServiceError.httpStatusCode(httpResponse.statusCode)
        }

        return data
    }

    func send<T: Decodable>(request: NetworkRequest, type: T.Type) async throws -> T {
        let data = try await send(request: request)
        return try parse(data: data, type: type)
    }

    // MARK: - Private methods
    private func createRequest(request: NetworkRequest) -> URLRequest? {
        guard let endpoint = request.endPoint else {
            assertionFailure("")
            return nil
        }

        var urlRequest = URLRequest(url: endpoint)
        urlRequest.httpMethod = request.httpMethod.name

        return urlRequest
    }

    private func parse<T: Decodable>(data: Data, type: T.Type) throws -> T {
        do {
            let parsedData = try decoder.decode(T.self, from: data)
            return parsedData
        } catch {
            throw NetworkingServiceError.parsingError
        }
    }
}
