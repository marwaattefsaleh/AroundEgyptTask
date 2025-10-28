//
//  MockRemoteDataSource.swift
//  AroundEgyptTask
//
//  Created by Marwa Attef on 28/10/2025.
//
import XCTest
import Foundation
import Alamofire
@testable import AroundEgyptTask

class MockRemoteDataSource: ExperienceRemoteDataSourceProtocol {
    var experiences: [ExperienceDTO] = []
    var experienceDetail: ExperienceDTO?
    var likedExperience: ExperienceDTO?
    
    func getExperiences(filter: [String: Any]?) async throws -> [ExperienceDTO] {
        return experiences
    }
    
    func getExperienceDetails(by id: String) async throws -> ExperienceDTO? {
        return experienceDetail
    }
    
    func likeExperience(id: String) async throws -> Int? {
        return likedExperience?.likesNo
    }
}
