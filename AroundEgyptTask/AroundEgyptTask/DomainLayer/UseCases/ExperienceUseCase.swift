//
//  ExperienceUseCase.swift
//  AroundEgyptTask
//
//  Created by Marwa Attef on 28/10/2025.
//

protocol ExperienceUseCaseProtocol {
    func getRecommendedExperiences(isOnline: Bool) async throws -> [ExperienceEntity]
    func getRecentExperiences(isOnline: Bool) async throws -> [ExperienceEntity]
    func searchExperience(by searchText: String, isOnline: Bool) async throws -> [ExperienceEntity]
    func likeExperience(id: String, isOnline: Bool) async throws -> Int?
    func getExperienceDetails(id: String, isOnline: Bool) async throws -> ExperienceEntity?
}

class ExperienceUseCase: ExperienceUseCaseProtocol {
    private let repository: ExperienceRepositoryProtocol
    
    init(repository: ExperienceRepositoryProtocol) {
        self.repository = repository
    }
    
    func getRecommendedExperiences(isOnline: Bool) async throws -> [ExperienceEntity] {
        if isOnline {
            try await repository.getRecommendedExperiences()
        } else {
            try await repository.getRecommendedExperiencesLocaly()
        }
    }
    
    func getRecentExperiences(isOnline: Bool) async throws -> [ExperienceEntity] {
        if isOnline {
            try await repository.getRecentExperiences()
        } else {
            try await repository.getRecentExperiencesLocaly()
        }
    }
    
    func searchExperience(by searchText: String, isOnline: Bool) async throws -> [ExperienceEntity] {
        if isOnline {
            try await repository.searchExperiences(by: searchText)
        } else {
            try await repository.searchExperienceLocaly(by: searchText)
        }
    }
    
    func likeExperience(id: String, isOnline: Bool) async throws -> Int? {
        try await repository.likeExperience(id: id)
    }
    
    func getExperienceDetails(id: String, isOnline: Bool) async throws -> ExperienceEntity? {
        if isOnline {
            try await repository.getExperienceDetails(by: id)
        } else {
            try await repository.getExperienceDetailsLocaly(by: id)
        }
    }
}
