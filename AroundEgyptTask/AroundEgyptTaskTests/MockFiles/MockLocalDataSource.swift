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
    var experienceDetail: ExperienceDBModel!
    var searchedExperiences: [ExperienceDBModel] = []
    var likedExperience: ExperienceDBModel?
    
    func saveExperiences(items: [ExperienceDBModel]) async throws {
        savedExperiencesCalled = true
    }
    
    func getRecommendedExperiences() async throws -> [ExperienceDBModel] {
        return recommended
    }
    
    func getRecentExperiences() async throws -> [ExperienceDBModel] {
        return recent
    }
    
    func getExperienceDetails(by id: String) async throws -> ExperienceDBModel {
        return experienceDetail
    }
    
    func searchExperiences(by searchText: String) async throws -> [ExperienceDBModel] {
        return searchedExperiences
    }
    
    func likeExperience(id: String) async throws -> ExperienceDBModel? {
        return likedExperience
    }
}
