//
//  NetworkService.swift
//  AroundEgyptTask
//
//  Created by Marwa Attef on 28/10/2025.
//

import Foundation
import Alamofire

protocol NetworkServiceProtocol {
    func request<T: Decodable>(
        endpoint: String,
        method: HTTPMethod,
        parameters: [String: Any]?,
        headers: HTTPHeaders?
    ) async throws -> T
}
 class NetworkService: NetworkServiceProtocol {
    private let config: AppConfigurationProtocol
    private let session: Session

    init(config: AppConfigurationProtocol) {
        self.config = config
        
        // Retry policy
        let retrier = NetworkRequestRetrier()
        self.session = Session(interceptor: retrier)
    }

    func request<T: Decodable>(
        endpoint: String,
        method: HTTPMethod = .get,
        parameters: [String: Any]? = nil,
        headers: HTTPHeaders? = nil
    ) async throws -> T {
        
        guard let url = URL(string: config.baseURL + endpoint) else {
            throw NetworkError.invalidURL
        }

        let finalHeaders = headers ?? HTTPHeaders()

        do {
            let dataTask = session.request(
                url,
                method: method,
                parameters: parameters,
                encoding: method == .get ? URLEncoding.default : JSONEncoding.default,
                headers: finalHeaders
            )

            let response = await dataTask.serializingDecodable(T.self).response

            switch response.result {
            case .success(let data):
                return data
            case .failure(let afError):
                if let code = response.response?.statusCode {
                    switch code {
                    case 401: throw NetworkError.unauthorized
                    case 404: throw NetworkError.notFound
                    case 500...599:
                        let message = try? JSONDecoder().decode(BaseResponse<String>.self, from: response.data ?? Data()).meta.errors?.first?.message
                        throw NetworkError.serverError(message: message)
                    default: break
                    }
                }

                if afError.isSessionTaskError { throw NetworkError.noInternet }
                if afError.isResponseSerializationError { throw NetworkError.decodingError }

                throw NetworkError.unknownError(error: afError)
            }
        } catch {
            throw NetworkError.unknownError(error: error)
        }
    }
}
