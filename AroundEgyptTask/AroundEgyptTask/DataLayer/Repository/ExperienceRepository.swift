//
//  ExperienceRepository.swift
//  AroundEgyptTask
//
//  Created by Marwa Attef on 28/10/2025.
//

import Foundation

protocol ExperienceRepositoryProtocol: AnyObject {
    func getRecommendedExperiences() async throws -> [ExperienceEntity]
    func getRecentExperiences() async throws -> [ExperienceEntity]
    func getExperienceDetails(by id: String) async throws -> ExperienceEntity?
    func searchExperiences(by searchText: String) async throws -> [ExperienceEntity]
    func likeExperience(id: String) async throws -> ExperienceEntity?
    
    func saveExperiencesToLocalDB(_ experiences: [ExperienceDTO], isRecent: Bool) async throws
    func getExperienceDetailsLocaly(by id: String) async throws -> ExperienceEntity?
    func getRecentExperiencesLocaly() async throws -> [ExperienceEntity]
    func getRecommendedExperiencesLocaly() async throws -> [ExperienceEntity]
    func searchExperienceLocaly(by searchText: String) async throws -> [ExperienceEntity]
    func likeExperienceLocaly(id: String) async throws -> ExperienceEntity?
}

class ExperienceRepository: ExperienceRepositoryProtocol {
    private let remoteDataSource: ExperienceRemoteDataSourceProtocol
    private let localeDataSource: ExperienceLocalDataSourceProtocol

    init(remoteDataSource: ExperienceRemoteDataSourceProtocol, localeDataSource: ExperienceLocalDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
        self.localeDataSource = localeDataSource
    }

    func getRecommendedExperiences() async throws -> [ExperienceEntity] {
        let dtos = try await remoteDataSource.getExperiences(filter: ["filter[recommended]": true])
        if !dtos.isEmpty {
            try await saveExperiencesToLocalDB(dtos, isRecent: false)
        }
        return dtos.map { $0.toEntity(isRecent: false)}
    }

    func getRecentExperiences() async throws -> [ExperienceEntity] {
        let dtos = try await remoteDataSource.getExperiences(filter: nil)
        try await saveExperiencesToLocalDB(dtos, isRecent: true)
        return dtos.map { $0.toEntity(isRecent: true)}
    }

    func getExperienceDetails(by id: String) async throws -> ExperienceEntity? {
        let dto = try await remoteDataSource.getExperienceDetails(by: id)
        return dto?.toEntity(isRecent: false)
    }
    
    func searchExperiences(by searchText: String) async throws -> [ExperienceEntity] {
        let dtos = try await remoteDataSource.getExperiences(filter: ["filter[title]": searchText])
        return dtos.map { $0.toEntity(isRecent: true)}
    }
    
    func likeExperience(id: String) async throws -> ExperienceEntity? {
        let dto = try await remoteDataSource.likeExperience(id: id)
        _ = try await self.likeExperienceLocaly(id: id)
        return dto?.toEntity()
    }
    
    func getRecommendedExperiencesLocaly() async throws -> [ExperienceEntity] {
        let dbModels = try await localeDataSource.getRecommendedExperiences()
        return dbModels.map { $0.toEntity()}
    }
    
    func getRecentExperiencesLocaly() async throws -> [ExperienceEntity] {
        let dbModels = try await localeDataSource.getRecentExperiences()
        return dbModels.map { $0.toEntity()}
    }
    
    func getExperienceDetailsLocaly(by id: String) async throws -> ExperienceEntity? {
        let dbModel = try await localeDataSource.getExperienceDetails(by: id)
        return dbModel.toEntity()
    }
    
    func saveExperiencesToLocalDB(_ experiences: [ExperienceDTO], isRecent: Bool) async throws {
       let dbModels = experiences.map { $0.toDBModel(isRecent: isRecent)}
        try await localeDataSource.saveExperiences(items: dbModels)
    }
    
    func searchExperienceLocaly(by searchText: String) async throws -> [ExperienceEntity] {
        let dbModels = try await localeDataSource.searchExperiences(by: searchText)
        return dbModels.map { $0.toEntity()}
    }
    
    func likeExperienceLocaly(id: String) async throws -> ExperienceEntity? {
        let dbModel = try await localeDataSource.likeExperience(id: id)
        return dbModel?.toEntity()
    }
}
