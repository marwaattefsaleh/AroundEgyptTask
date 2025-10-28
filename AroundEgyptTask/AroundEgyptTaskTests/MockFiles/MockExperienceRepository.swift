//
//  MockExperienceRepository.swift
//  AroundEgyptTask
//
//  Created by Marwa Attef on 28/10/2025.
//
import XCTest
import Foundation
import Alamofire
@testable import AroundEgyptTask

class MockExperienceRepository: ExperienceRepositoryProtocol {
    
    var recommendedOnline: [ExperienceEntity] = []
    var recentOnline: [ExperienceEntity] = []
    var searchedOnline: [ExperienceEntity] = []
    var likedEntity: ExperienceEntity?
    var detailsOnline: ExperienceEntity?

    var recommendedLocal: [ExperienceEntity] = []
    var recentLocal: [ExperienceEntity] = []
    var searchedLocal: [ExperienceEntity] = []
    var detailsLocal: ExperienceEntity?

    func getRecommendedExperiences() async throws -> [ExperienceEntity] { recommendedOnline }
    func getRecentExperiences() async throws -> [ExperienceEntity] { recentOnline }
    func searchExperiences(by searchText: String) async throws -> [ExperienceEntity] { searchedOnline }
    func likeExperience(id: String) async throws -> Int? { likedEntity?.likesNo }
    func getExperienceDetails(by id: String) async throws -> ExperienceEntity? { detailsOnline }

    func saveExperiencesToLocalDB(_ experiences: [AroundEgyptTask.ExperienceDTO], isRecommended: Bool, isRecent: Bool) async throws {}
    func getExperienceDetailsLocaly(by id: String) async throws -> ExperienceEntity? { detailsLocal }
    func getRecentExperiencesLocaly() async throws -> [ExperienceEntity] { recentLocal }
    func getRecommendedExperiencesLocaly() async throws -> [ExperienceEntity] { recommendedLocal }
    func searchExperienceLocaly(by searchText: String) async throws -> [ExperienceEntity] { searchedLocal }
    func likeExperienceLocaly(id: String, likesNo: Int) async throws -> ExperienceEntity? { likedEntity }
    func saveOrUpdateExperience(_ item: AroundEgyptTask.ExperienceDTO) async throws {
    }
}
