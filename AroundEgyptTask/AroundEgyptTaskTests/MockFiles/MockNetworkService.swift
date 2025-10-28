//
//  MockNetworkService.swift
//  AroundEgyptTask
//
//  Created by Marwa Attef on 28/10/2025.
//
import XCTest
import Foundation
import Alamofire
@testable import AroundEgyptTask

// MARK: - Mock Network Service
class MockNetworkService: NetworkServiceProtocol {
    var result: Result<Any, Error>?

    func request<T>(endpoint: String, method: HTTPMethod, parameters: [String : Any]?, headers: HTTPHeaders?) async throws -> T where T : Decodable {
        switch result {
        case .success(let data):
            guard let typed = data as? T else {
                throw NetworkError.decodingError
            }
            return typed
        case .failure(let error):
            throw error
        case .none:
            throw NetworkError.unknownError(error: NSError(domain: "", code: -1))
        }
    }
}
