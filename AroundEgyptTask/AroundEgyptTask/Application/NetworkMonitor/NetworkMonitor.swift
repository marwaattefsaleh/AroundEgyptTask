//
//  NetworkMonitor.swift
//  AroundEgyptTask
//
//  Created by Marwa Attef on 28/10/2025.
//

import Network
import Combine

protocol NetworkMonitorProtocol {
    var isConnected: Bool { get }
    var connectionPublisher: AnyPublisher<Bool, Never> { get }
}

final class NetworkMonitor: NetworkMonitorProtocol {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    private let subject = CurrentValueSubject<Bool, Never>(false)

    var connectionPublisher: AnyPublisher<Bool, Never> {
        subject.eraseToAnyPublisher()
    }

    var isConnected: Bool {
        subject.value
    }

    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            let connected = path.status == .satisfied
            DispatchQueue.main.async {
                self?.subject.send(connected)
            }
        }
        monitor.start(queue: queue)
    }

    deinit {
        monitor.cancel()
    }
}
