//
//  NetworkRequestRetrier.swift
//  AroundEgyptTask
//
//  Created by Marwa Attef on 28/10/2025.
//

import Alamofire
final class NetworkRequestRetrier: RequestInterceptor {
    private let maxRetryCount = 2

    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard request.retryCount < maxRetryCount else {
            completion(.doNotRetry)
            return
        }

        if let afError = error.asAFError, afError.isSessionTaskError {
            completion(.retryWithDelay(1.0))
        } else {
            completion(.doNotRetry)
        }
    }
}
