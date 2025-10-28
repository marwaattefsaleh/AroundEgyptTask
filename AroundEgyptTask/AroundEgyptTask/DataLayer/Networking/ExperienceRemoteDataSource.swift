//
//  ExperienceRemoteDataSource.swift
//  AroundEgyptTask
//
//  Created by Marwa Attef on 28/10/2025.
//

import Foundation

protocol ExperienceRemoteDataSourceProtocol {
    func getExperiences(filter: [String: Any]?) async throws -> [ExperienceDTO] 
    func getExperienceDetails(by id: String) async throws -> ExperienceDTO?
    func likeExperience(id: String) async throws -> Int?
}

class ExperienceRemoteDataSource: ExperienceRemoteDataSourceProtocol {
    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func getExperiences(filter: [String: Any]?) async throws -> [ExperienceDTO] {
        let response: BaseResponse<[ExperienceDTO]> = try await networkService.request(
            endpoint: "\(Constants.basePath)\(Constants.Endpoints.experiences)",
            method: .get,
            parameters: filter, headers: nil
        )
        return response.data ?? []
    }
  
    func getExperienceDetails(by id: String) async throws -> ExperienceDTO? {
        let response: BaseResponse<ExperienceDTO> = try await networkService.request(
            endpoint: "\(Constants.basePath)\(Constants.Endpoints.experiences)/\(id)",
            method: .get, parameters: nil, headers: nil
        )
      
        return response.data
    }
    
    func likeExperience(id: String) async throws -> Int? {
        let response: BaseResponse<Int> = try await networkService.request(
            endpoint: "\(Constants.basePath)\(Constants.Endpoints.experiences)/\(id)\(Constants.Endpoints.likeExperience)",
            method: .post, parameters: nil, headers: nil
        )
        return response.data
    }
}
