//
//  NetworkError.swift
//  AroundEgyptTask
//
//  Created by Marwa Attef on 28/10/2025.
//
import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case noInternet
    case unauthorized
    case notFound
    case serverError(message: String?)
    case decodingError
    case unknownError(error: Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The request URL is invalid."
        case .noInternet:
            return "No internet connection. Please check your network."
        case .unauthorized:
            return "Unauthorized request. Please log in again."
        case .notFound:
            return "The requested resource was not found."
        case .serverError(let message):
            return message ?? "Server encountered an error."
        case .decodingError:
            return "Failed to decode server response."
        case .unknownError(let error):
            return "Unexpected error occurred: \(error.localizedDescription)"
        }
    }
}
