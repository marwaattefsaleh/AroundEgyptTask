//
//  MockExperienceUseCase.swift
//  AroundEgyptTask
//
//  Created by Marwa Attef on 28/10/2025.
//
import XCTest
import Foundation
import Alamofire
@testable import AroundEgyptTask

class MockExperienceUseCase: ExperienceUseCaseProtocol {
    // MARK: - Stored mock data and control flags

    var experienceToReturn: ExperienceEntity?
    var likedExperience: ExperienceEntity?
    var shouldThrow = false

    // Optional closures for custom behavior in individual tests
    var getRecommendedExperiencesHandler: ((Bool) throws -> [ExperienceEntity])?
    var getRecentExperiencesHandler: ((Bool) throws -> [ExperienceEntity])?
    var searchExperienceHandler: ((String, Bool) throws -> [ExperienceEntity])?

    // MARK: - ExperienceUseCaseProtocol methods

    func getRecommendedExperiences(isOnline: Bool) async throws -> [ExperienceEntity] {
        if let handler = getRecommendedExperiencesHandler {
            return try handler(isOnline)
        }
        if shouldThrow { throw URLError(.badServerResponse) }
        if let entity = experienceToReturn { return [entity] }
        return []
    }

    func getRecentExperiences(isOnline: Bool) async throws -> [ExperienceEntity] {
        if let handler = getRecentExperiencesHandler {
            return try handler(isOnline)
        }
        if shouldThrow { throw URLError(.badServerResponse) }
        if let entity = experienceToReturn { return [entity] }
        return []
    }

    func searchExperience(by searchText: String, isOnline: Bool) async throws -> [ExperienceEntity] {
        if let handler = searchExperienceHandler {
            return try handler(searchText, isOnline)
        }
        if shouldThrow { throw URLError(.badServerResponse) }
        if let entity = experienceToReturn { return [entity] }
        return []
    }

    func likeExperience(id: String, isOnline: Bool) async throws -> Int? {
        if shouldThrow { throw URLError(.badServerResponse) }
        return likedExperience?.likesNo
    }

    func getExperienceDetails(id: String, isOnline: Bool) async throws -> ExperienceEntity? {
        if shouldThrow { throw URLError(.badServerResponse) }
        return experienceToReturn
    }
}
