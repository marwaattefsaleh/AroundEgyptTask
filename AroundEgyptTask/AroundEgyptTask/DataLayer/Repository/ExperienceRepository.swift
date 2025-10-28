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
    func likeExperience(id: String) async throws -> Int?
    
    func saveExperiencesToLocalDB(_ experiences: [ExperienceDTO], isRecommended: Bool, isRecent: Bool) async throws
    func getExperienceDetailsLocaly(by id: String) async throws -> ExperienceEntity?
    func getRecentExperiencesLocaly() async throws -> [ExperienceEntity]
    func getRecommendedExperiencesLocaly() async throws -> [ExperienceEntity]
    func searchExperienceLocaly(by searchText: String) async throws -> [ExperienceEntity]
    func likeExperienceLocaly(id: String, likesNo: Int) async throws -> ExperienceEntity?
    func saveOrUpdateExperience(_ item: ExperienceDTO) async throws
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
            try await saveExperiencesToLocalDB(dtos, isRecommended: true, isRecent: false)
        }
        let localExperiences = try await getRecommendedExperiencesLocaly()
        
        return localExperiences
    }
    
    func getRecentExperiences() async throws -> [ExperienceEntity] {
        let dtos = try await remoteDataSource.getExperiences(filter: nil)
        try await saveExperiencesToLocalDB(dtos, isRecommended: false, isRecent: true)
        let localExperiences = try await getRecentExperiencesLocaly()
        
        return localExperiences
    }
    
    func getExperienceDetails(by id: String) async throws -> ExperienceEntity? {
        let dto = try await remoteDataSource.getExperienceDetails(by: id)
        if dto == nil {
            try await saveOrUpdateExperience(dto!)
            
        }
        let localExperience = try await getExperienceDetailsLocaly(by: id)
        return localExperience
    }
    
    func searchExperiences(by searchText: String) async throws -> [ExperienceEntity] {
        let dtos = try await remoteDataSource.getExperiences(filter: ["filter[title]": searchText])
        return dtos.map { $0.toEntity(isRecent: true)}
    }
    
    func likeExperience(id: String) async throws -> Int? {
        let likesNo = try await remoteDataSource.likeExperience(id: id)
        _ = try await self.likeExperienceLocaly(id: id, likesNo: likesNo ?? 0)
        return likesNo
    }
    
    func getRecommendedExperiencesLocaly() async throws -> [ExperienceEntity] {
        let dbModels = try await localeDataSource.getRecommendedExperiences()
        return dbModels
    }
    
    func getRecentExperiencesLocaly() async throws -> [ExperienceEntity] {
        let dbModels = try await localeDataSource.getRecentExperiences()
        return dbModels
    }
    
    func getExperienceDetailsLocaly(by id: String) async throws -> ExperienceEntity? {
        let dbModel = try await localeDataSource.getExperienceDetails(by: id)
        return dbModel
    }
    
    func saveExperiencesToLocalDB(_ experiences: [ExperienceDTO], isRecommended: Bool, isRecent: Bool) async throws {
        let dbModels = experiences.map { $0.toDBModel(isRecent: isRecent)}
        try await localeDataSource.saveExperiences(items: dbModels, isRecommended: isRecommended, isRecent: isRecent)
    }
    
    func searchExperienceLocaly(by searchText: String) async throws -> [ExperienceEntity] {
        let dbModels = try await localeDataSource.searchExperiences(by: searchText)
        return dbModels
    }
    
    func likeExperienceLocaly(id: String, likesNo: Int) async throws -> ExperienceEntity? {
        let dbModel = try await localeDataSource.likeExperience(id: id, likesNo: likesNo)
        return dbModel
    }
    
    func saveOrUpdateExperience(_ item: ExperienceDTO) async throws {
        let dbModel = item.toDBModel()
        try await localeDataSource.saveOrUpdateExperience(dbModel)
    }
}
