//
//  HomeViewModelTests.swift
//  AroundEgyptTask
//
//  Created by Marwa Attef on 28/10/2025.
//

import XCTest
import Foundation
import Alamofire
@testable import AroundEgyptTask

@MainActor
final class HomeViewModelTests: XCTestCase {
    
    var sut: HomeViewModel!
    var mockUseCase: MockExperienceUseCase!
    var mockRouter: MockHomeRouter!
    var mockNetwork: MockNetworkMonitor!
    
    override func setUp() {
        super.setUp()
        mockUseCase = MockExperienceUseCase()
        mockRouter = MockHomeRouter()
        mockNetwork = MockNetworkMonitor(isConnected: true)
        sut = HomeViewModel(experienceUseCase: mockUseCase,
                            router: mockRouter,
                            networkMonitor: mockNetwork)
    }
    
    override func tearDown() {
        sut = nil
        mockUseCase = nil
        mockRouter = nil
        mockNetwork = nil
        super.tearDown()
    }
    
    // MARK: - getData()
    func test_getData_triggersBothRecommendedAndRecent() async {
        // Given
        mockUseCase.shouldThrow = false
        
        // When
        sut.getData()
        
        // Then (async delay to let Tasks finish)
        try? await Task.sleep(nanoseconds: 100_000_000)
        XCTAssertFalse(sut.isLoadingRecommended)
        XCTAssertFalse(sut.isLoadingRecent)
        XCTAssertFalse(sut.isFromSearch)
    }
    
    // MARK: - getRecommendedExperiences
    func test_getRecommendedExperiences_success_updatesList() async {
        // Given
        let entity = ExperienceEntity(id: "1", title: "Pyramids", desc: "Ancient site",
                                      coverPhoto: nil, likesNo: 0, viewsNo: 0,
                                      isRecommended: true, isRecent: false,
                                      isLiked: false, cityName: "Cairo", order: 0)
        mockUseCase.getRecommendedExperiencesHandler = { _ in [entity] }
        
        // When
        sut.getRecommendedExperiences()
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        // Then
        XCTAssertEqual(sut.recommendedExperienceEntityList.count, 1)
        XCTAssertEqual(sut.recommendedExperienceEntityList.first?.id, "1")
        XCTAssertFalse(sut.isLoadingRecommended)
        XCTAssertFalse(sut.showToast)
    }
    
    func test_getRecommendedExperiences_failure_showsToast() async {
        // Given
        mockUseCase.shouldThrow = true
        
        // When
        sut.getRecommendedExperiences()
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        // Then
        XCTAssertTrue(sut.showToast)
        XCTAssertFalse(sut.isLoadingRecommended)
    }
    
    // MARK: - getRecentExperiences
    func test_getRecentExperiences_success_updatesList() async {
        // Given
        let entity = ExperienceEntity(id: "2", title: "Nile River", desc: nil,
                                      coverPhoto: nil, likesNo: 1, viewsNo: 10,
                                      isRecommended: false, isRecent: true,
                                      isLiked: false, cityName: "Luxor", order: 0)
        mockUseCase.getRecentExperiencesHandler = { _ in [entity] }
        
        // When
        sut.getRecentExperiences()
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        // Then
        XCTAssertEqual(sut.recentExperienceEntityList.count, 1)
        XCTAssertEqual(sut.recentExperienceEntityList.first?.title, "Nile River")
        XCTAssertFalse(sut.isLoadingRecent)
    }
    
    func test_getRecentExperiences_failure_showsToast() async {
        // Given
        mockUseCase.shouldThrow = true
        
        // When
        sut.getRecentExperiences()
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        // Then
        XCTAssertTrue(sut.showToast)
        XCTAssertFalse(sut.isLoadingRecent)
    }
    
    // MARK: - performSearch
    func test_performSearch_success_updatesRecentList() async {
        // Given
        let entity = ExperienceEntity(id: "3", title: "Desert Safari", desc: nil,
                                      coverPhoto: nil, likesNo: 5, viewsNo: 200,
                                      isRecommended: false, isRecent: false,
                                      isLiked: false, cityName: "Giza", order: 0)
        mockUseCase.searchExperienceHandler = { _, _ in [entity] }
        
        // When
        sut.performSearch(searchText: "Desert")
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        // Then
        XCTAssertTrue(sut.isFromSearch)
        XCTAssertFalse(sut.isLoadingRecent)
        XCTAssertEqual(sut.recentExperienceEntityList.first?.title, "Desert Safari")
    }
    
    func test_performSearch_failure_showsToast() async {
        // Given
        mockUseCase.shouldThrow = true
        
        // When
        sut.performSearch(searchText: "anything")
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        // Then
        XCTAssertTrue(sut.showToast)
        XCTAssertFalse(sut.isLoadingRecent)
    }
    
    func test_likeExperience_failure_showsToast() async {
        // Given
        mockUseCase.shouldThrow = true
        
        // When
        sut.likeExperience(id: "no_id")
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        // Then
        XCTAssertTrue(sut.showToast)
    }
    
    // MARK: - Navigation
    func test_navigateToDetail_callsRouter() {
        let entity = ExperienceEntity(id: "123", title: "Desert Safari", desc: nil,
                                      coverPhoto: nil, likesNo: 5, viewsNo: 200,
                                      isRecommended: false, isRecent: false,
                                      isLiked: false, cityName: "Giza", order: 0)
        // When
        _ = sut.navigateToDetail(experience: .constant(entity))
        
        // Then
        XCTAssertTrue(mockRouter.navigateCalled)
        XCTAssertEqual(mockRouter.passedExperience?.id, entity.id)
    }
}
