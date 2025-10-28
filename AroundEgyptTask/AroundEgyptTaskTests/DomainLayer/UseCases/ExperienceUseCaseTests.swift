//
//  ExperienceUseCaseTests.swift
//  AroundEgyptTask
//
//  Created by Marwa Attef on 28/10/2025.
//

import XCTest
@testable import AroundEgyptTask

// MARK: - Test Case
final class ExperienceUseCaseTests: XCTestCase {

    var useCase: ExperienceUseCase!
    var mockRepository: MockExperienceRepository!

    override func setUp() {
        super.setUp()
        mockRepository = MockExperienceRepository()
        useCase = ExperienceUseCase(repository: mockRepository)
    }

    override func tearDown() {
        useCase = nil
        mockRepository = nil
        super.tearDown()
    }

    // MARK: - Helpers
    func makeEntity(id: String = "1") -> ExperienceEntity {
        return ExperienceEntity(
            id: id,
            title: "Test",
            desc: "Desc",
            coverPhoto: nil,
            likesNo: 0,
            viewsNo: 0,
            isRecommended: false,
            isRecent: false,
            isLiked: false,
            cityName: nil, order: 0
        )
    }

    // MARK: - getRecommendedExperiences
    func test_getRecommendedExperiences_online_returnsOnline() async throws {
        let entity = makeEntity()
        mockRepository.recommendedOnline = [entity]

        let result = try await useCase.getRecommendedExperiences(isOnline: true)
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.id, entity.id)
    }

    func test_getRecommendedExperiences_offline_returnsLocal() async throws {
        let entity = makeEntity()
        mockRepository.recommendedLocal = [entity]

        let result = try await useCase.getRecommendedExperiences(isOnline: false)
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.id, entity.id)
    }

    // MARK: - getRecentExperiences
    func test_getRecentExperiences_online_returnsOnline() async throws {
        let entity = makeEntity()
        mockRepository.recentOnline = [entity]

        let result = try await useCase.getRecentExperiences(isOnline: true)
        XCTAssertEqual(result.first?.id, entity.id)
    }

    func test_getRecentExperiences_offline_returnsLocal() async throws {
        let entity = makeEntity()
        mockRepository.recentLocal = [entity]

        let result = try await useCase.getRecentExperiences(isOnline: false)
        XCTAssertEqual(result.first?.id, entity.id)
    }

    // MARK: - searchExperience
    func test_searchExperience_online_returnsOnline() async throws {
        let entity = makeEntity()
        mockRepository.searchedOnline = [entity]

        let result = try await useCase.searchExperience(by: "query", isOnline: true)
        XCTAssertEqual(result.first?.id, entity.id)
    }

    func test_searchExperience_offline_returnsLocal() async throws {
        let entity = makeEntity()
        mockRepository.searchedLocal = [entity]

        let result = try await useCase.searchExperience(by: "query", isOnline: false)
        XCTAssertEqual(result.first?.id, entity.id)
    }

    // MARK: - getExperienceDetails
    func test_getExperienceDetails_online_returnsEntity() async throws {
        let entity = makeEntity()
        mockRepository.detailsOnline = entity

        let result = try await useCase.getExperienceDetails(id: "1", isOnline: true)
        XCTAssertEqual(result?.id, entity.id)
    }

    func test_getExperienceDetails_offline_returnsEntity() async throws {
        let entity = makeEntity()
        mockRepository.detailsLocal = entity

        let result = try await useCase.getExperienceDetails(id: "1", isOnline: false)
        XCTAssertEqual(result?.id, entity.id)
    }
}
