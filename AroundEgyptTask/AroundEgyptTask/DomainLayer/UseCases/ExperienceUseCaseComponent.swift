//
//  ExperienceUseCaseComponent.swift
//  AroundEgyptTask
//
//  Created by Marwa Attef on 28/10/2025.
//

import NeedleFoundation
import SwiftData
protocol ExperienceUseCaseDependency: Dependency {
    var networkService: NetworkServiceProtocol { get }
    var experienceModelActor: ExperienceModelActor { get }
}

class ExperienceUseCaseComponent: Component<ExperienceUseCaseDependency> {
    var experienceRemoteDataSource: ExperienceRemoteDataSourceProtocol {
        ExperienceRemoteDataSource(networkService: dependency.networkService)
    }
    var experienceLocalDataSource: ExperienceLocalDataSourceProtocol {
        ExperienceLocalDataSource(actor: dependency.experienceModelActor)
    }
    
    var experienceRepository: ExperienceRepositoryProtocol {
        ExperienceRepository(
            remoteDataSource: experienceRemoteDataSource, localeDataSource: experienceLocalDataSource)
    }
    
    var useCase: ExperienceUseCase {
        return .init(repository: experienceRepository)
    }
    
}
