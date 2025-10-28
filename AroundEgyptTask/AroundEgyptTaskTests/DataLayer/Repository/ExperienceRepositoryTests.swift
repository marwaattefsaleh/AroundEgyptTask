//
//  ExperienceRepositoryTests.swift
//  AroundEgyptTask
//
//  Created by Marwa Attef on 28/10/2025.
//

import XCTest
@testable import AroundEgyptTask

final class ExperienceRepositoryTests: XCTestCase {
    
    var sut: ExperienceRepository!
    var mockRemote: MockRemoteDataSource!
    var mockLocal: MockLocalDataSource!
    
    override func setUp() {
        super.setUp()
        mockRemote = MockRemoteDataSource()
        mockLocal = MockLocalDataSource()
        sut = ExperienceRepository(remoteDataSource: mockRemote, localeDataSource: mockLocal)
    }
    
    override func tearDown() {
        sut = nil
        mockRemote = nil
        mockLocal = nil
        super.tearDown()
    }
    
    // MARK: - Helpers
    func makeDTO(id: String = "1", title: String = "Test") -> ExperienceDTO {
        return ExperienceDTO(
            id: id, title: title, coverPhoto: nil, desc: "Desc",
            viewsNo: 10, likesNo: 5, recommended: 1, hasVideo: 0,
            tags: nil, city: nil, tourHTML: nil, famousFigure: nil,
            period: nil, era: nil, founded: nil, detailedDescription: nil,
            address: nil, gmapLocation: nil, openingHours: nil,
            translatedOpeningHours: nil, startingPrice: nil,
            ticketPrices: nil, experienceTips: nil, isLiked: false,
            reviews: nil, rating: nil, reviewsNo: nil, audioURL: nil, hasAudio: false
        )
    }
    
    func makeDBModel(id: String = "1") -> ExperienceDBModel {
        return ExperienceDBModel(id: id, title: "Test", desc: "Desc", coverPhoto: nil,
                                 likesNo: 5, viewsNo: 10, isRecommended: true,
                                 isRecent: false, isLiked: false, cityName: nil)
    }
    
    // MARK: - Remote Methods
    
    func test_getRecommendedExperiences_success_savesToLocal() async throws {
        let dto = makeDTO()
        mockRemote.experiences = [dto]
        
        let result = try await sut.getRecommendedExperiences()
        
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0].id, dto.id)
        XCTAssertTrue(mockLocal.savedExperiencesCalled)
    }
    
    func test_getRecentExperiences_success_savesToLocal() async throws {
        let dto = makeDTO()
        mockRemote.experiences = [dto]
        mockLocal.recent = [dto.toDBModel(isRecent: true)]

        let result = try await sut.getRecentExperiences()
        
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0].id, dto.id)
        XCTAssertTrue(mockLocal.savedExperiencesCalled)
    }
    
    func test_getExperienceDetails_success() async throws {
        let dto = makeDTO(id: "42")
        mockRemote.experienceDetail = dto
        
        let result = try await sut.getExperienceDetails(by: "42")
        XCTAssertEqual(result?.id, dto.id)
    }
    
    func test_searchExperiences_success() async throws {
        let dto = makeDTO(id: "search1")
        mockRemote.experiences = [dto]
        
        let result = try await sut.searchExperiences(by: "search")
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0].id, dto.id)
    }
    
    func test_likeExperience_success() async throws {
        let dto = makeDTO(id: "like1")
        mockRemote.likedExperience = dto
        
        let likesNo = try await sut.likeExperience(id: "like1")
        XCTAssertEqual(likesNo, dto.likesNo)
    }
    
    // MARK: - Local Methods
    
    func test_getRecommendedExperiencesLocaly_success() async throws {
        let db = makeDBModel(id: "local1")
        mockLocal.recommended = [db]
        
        let result = try await sut.getRecommendedExperiencesLocaly()
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0].id, db.id)
    }
    
    func test_getRecentExperiencesLocaly_success() async throws {
        let db = makeDBModel(id: "local2")
        mockLocal.recent = [db]
        
        let result = try await sut.getRecentExperiencesLocaly()
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0].id, db.id)
    }
    
    func test_getExperienceDetailsLocaly_success() async throws {
        let db = makeDBModel(id: "local3")
        mockLocal.experienceDetail = db
        
        let result = try await sut.getExperienceDetailsLocaly(by: "local3")
        XCTAssertEqual(result?.id, db.id)
    }
    
    func test_searchExperienceLocaly_success() async throws {
        let db = makeDBModel(id: "searchLocal")
        mockLocal.searchedExperiences = [db]
        
        let result = try await sut.searchExperienceLocaly(by: "search")
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0].id, db.id)
    }
    
    func test_likeExperienceLocaly_success() async throws {
        let db = makeDBModel(id: "likeLocal")
        mockLocal.likedExperience = db
        
        let result = try await sut.likeExperienceLocaly(id: "likeLocal", likesNo: 1)
        XCTAssertEqual(result?.id, db.id)
    }
    
    func test_saveExperiencesToLocalDB_callsLocal() async throws {
        let dto = makeDTO()
        try await sut.saveExperiencesToLocalDB([dto], isRecommended: false, isRecent: true)
        XCTAssertTrue(mockLocal.savedExperiencesCalled)
    }
}
