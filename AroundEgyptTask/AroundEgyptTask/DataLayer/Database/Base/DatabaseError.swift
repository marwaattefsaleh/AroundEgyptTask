//
//  DatabaseError.swift
//  AroundEgyptTask
//
//  Created by Marwa Attef on 28/10/2025.
//

import Foundation

enum DatabaseError: LocalizedError {  // ✅ Conforms to LocalizedError (which inherits from Error)
    case notFound
    case saveFailed(Error)
    case deleteFailed(Error)
    case fetchFailed(Error)
    case invalidData
    case unknown(Error)
    case updateFailed(Error)
    var errorDescription: String? {
        switch self {
        case .notFound:
            return "The requested data could not be found in the database."
        case .saveFailed(let error):
            return "Failed to save data: \(error.localizedDescription)"
        case .deleteFailed(let error):
            return "Failed to delete data: \(error.localizedDescription)"
        case .fetchFailed(let error):
            return "Failed to fetch data: \(error.localizedDescription)"
        case .invalidData:
            return "Invalid or corrupted data in the database."
        case .updateFailed(let error):
            return "Failed to update data: \(error.localizedDescription)"
        case .unknown(let error):
            return "An unknown database error occurred: \(error.localizedDescription)"
        }
    }
}
