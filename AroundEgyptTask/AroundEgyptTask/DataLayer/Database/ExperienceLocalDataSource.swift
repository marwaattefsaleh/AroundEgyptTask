//
//  ExperienceLocalDataSource.swift
//  AroundEgyptTask
//
//  Created by Marwa Attef on 28/10/2025.
//

import SwiftData
import Foundation
//
protocol ExperienceLocalDataSourceProtocol {
    func getRecommendedExperiences() async throws -> [ExperienceEntity]
    func getRecentExperiences() async throws -> [ExperienceEntity]
    func getExperienceDetails(by id: String) async throws -> ExperienceEntity
    func saveExperiences(items: [ExperienceDBModel], isRecommended: Bool, isRecent: Bool) async throws 
    func searchExperiences(by searchText: String) async throws -> [ExperienceEntity]
    func likeExperience(id: String, likesNo: Int) async throws -> ExperienceEntity?
    func saveOrUpdateExperience(_ item: ExperienceDBModel) async throws 
}

class ExperienceLocalDataSource: ExperienceLocalDataSourceProtocol {
    private let actor: ExperienceModelActor

    init(actor: ExperienceModelActor) {
        self.actor = actor
    }

    func getRecommendedExperiences() async throws -> [ExperienceEntity] {
        try await actor.getRecommendedExperiences()
    }

    func getRecentExperiences() async throws -> [ExperienceEntity] {
        try await actor.getRecentExperiences()
    }

    func getExperienceDetails(by id: String) async throws -> ExperienceEntity {
        try await actor.getExperienceDetails(by: id)
    }

    func saveExperiences(items: [ExperienceDBModel], isRecommended: Bool, isRecent: Bool) async throws {
        try await actor.saveExperiences(items: items, isRecommended: isRecommended, isRecent: isRecent)
    }

    func searchExperiences(by searchText: String) async throws -> [ExperienceEntity] {
        try await actor.searchExperiences(by: searchText)
    }

    func likeExperience(id: String, likesNo: Int) async throws -> ExperienceEntity? {
        try await actor.likeExperience(id: id, likesNo: likesNo)
    }
    
    func saveOrUpdateExperience(_ item: ExperienceDBModel) async throws {
        try await actor.saveOrUpdateExperience(item)
    }
}
