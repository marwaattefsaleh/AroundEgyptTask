//
//  MockNetworkMonitor.swift
//  AroundEgyptTask
//
//  Created by Marwa Attef on 28/10/2025.
//
import XCTest
import Foundation
import Alamofire
import Combine
@testable import AroundEgyptTask

class MockNetworkMonitor: NetworkMonitorProtocol {
    var isConnected: Bool
    var connectionPublisher: AnyPublisher<Bool, Never> {
        Just(isConnected).eraseToAnyPublisher()
    }
    
    init(isConnected: Bool = true) {
        self.isConnected = isConnected
    }
}
