//
//  ExperienceDetailsViewModelTests.swift
//  AroundEgyptTask
//
//  Created by Marwa Attef on 28/10/2025.
//

import XCTest
import Foundation
import Combine
@testable import AroundEgyptTask

@MainActor
final class ExperienceDetailsViewModelTests: XCTestCase {

    var sut: ExperienceDetailsViewModel!
    var mockUseCase: MockExperienceUseCase!
    var mockNetwork: MockNetworkMonitor!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockUseCase = MockExperienceUseCase()
        mockNetwork = MockNetworkMonitor()
        sut = ExperienceDetailsViewModel(experienceUseCase: mockUseCase, networkMonitor: mockNetwork)
        cancellables = []
    }

    override func tearDown() {
//        sut = nil
        mockUseCase = nil
        mockNetwork = nil
        cancellables = nil
        super.tearDown()
    }

    // MARK: - Tests

    func test_getExperienceDetails_success() async throws {
        // Given
        let expected = ExperienceEntity(
            id: "7f209d18-36a1-44d5-a0ed-b7eddfad48d6",
            title: "Pyramids",
            desc: "A great place",
            coverPhoto: nil,
            likesNo: 10,
            viewsNo: 100,
            isRecommended: true,
            isRecent: false,
            isLiked: false,
            cityName: "Cairo", order: 0
        )
        mockUseCase.experienceToReturn = expected
        mockNetwork.isConnected = true

        // When
        let expectation = XCTestExpectation(description: "Wait for data to load")
        sut.$experienceEntity
            .dropFirst() // wait until entity changes
            .sink { entity in
                if entity != nil { expectation.fulfill() }
            }
            .store(in: &cancellables)

        sut.getExperienceDetails(id: "1")

        await fulfillment(of: [expectation], timeout: 2.0)

        // Then
        XCTAssertFalse(sut.isLoading)
        XCTAssertEqual(sut.experienceEntity?.id, expected.id)
        XCTAssertFalse(sut.showToast)
    }

    func test_getExperienceDetails_failure_showsToast() async throws {
        // Given
        mockUseCase.shouldThrow = true
        mockNetwork.isConnected = true

        // When
        let expectation = XCTestExpectation(description: "Wait for toast to show")
        sut.$showToast
            .dropFirst()
            .sink { show in
                if show { expectation.fulfill() }
            }
            .store(in: &cancellables)

        sut.getExperienceDetails(id: "fail")

        await fulfillment(of: [expectation], timeout: 2.0)

        // Then
        XCTAssertTrue(sut.showToast)
        XCTAssertNotNil(sut.toastMessage)
        XCTAssertFalse(sut.isLoading)
    }

    func test_likeExperience_failure_showsToast() {
        // Given
        mockUseCase.shouldThrow = true
        mockNetwork.isConnected = true

        let expectation = XCTestExpectation(description: "Wait for toast on like fail")

        // When
        sut.likeExperience(id: "fail") { success in
            // Then
            XCTAssertFalse(success)
            XCTAssertTrue(self.sut.showToast)
            XCTAssertNotNil(self.sut.toastMessage)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5)
    }

}
