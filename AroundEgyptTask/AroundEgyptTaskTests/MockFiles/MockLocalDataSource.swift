//
//  MockLocalDataSource.swift
//  AroundEgyptTask
//
//  Created by Marwa Attef on 28/10/2025.
//
import XCTest
import Foundation
import Alamofire
@testable import AroundEgyptTask

class MockLocalDataSource: ExperienceLocalDataSourceProtocol {
    var savedExperiencesCalled = false
    var recommended: [ExperienceDBModel] = []
    var recent: [ExperienceDBModel] = []
    var searchedExperiences: [ExperienceDBModel] = []
    var likedExperience: ExperienceDBModel?
    var experienceDetail = ExperienceDBModel(
        id: "default",
        title: "Default",
        desc: "",
        coverPhoto: nil,
        likesNo: 0,
        viewsNo: 0,
        isRecommended: false,
        isRecent: true,
        isLiked: false,
        cityName: nil
    )

    func saveOrUpdateExperience(_ item: AroundEgyptTask.ExperienceDBModel) async throws {
        
    }
    
    func saveExperiences(items: [ExperienceDBModel], isRecommended: Bool, isRecent: Bool) async throws {
        savedExperiencesCalled = true
        if isRecommended { recommended = items } // ← add this
        if isRecent { recent = items }           // ← for recent tests
    }
    
    func getRecommendedExperiences() async throws -> [ExperienceEntity] {
        return recommended.map { $0.toEntity() }
    }
    
    func getRecentExperiences() async throws -> [ExperienceEntity] {
        return recent.map { $0.toEntity() }
    }
    
    func getExperienceDetails(by id: String) async throws -> ExperienceEntity {
        experienceDetail.id = id
        return experienceDetail.toEntity()
    }
    
    func searchExperiences(by searchText: String) async throws -> [ExperienceEntity] {
        return searchedExperiences.map { $0.toEntity() }
    }
    
    func likeExperience(id: String, likesNo: Int) async throws -> AroundEgyptTask.ExperienceEntity? {
        return likedExperience?.toEntity()
    }
}
