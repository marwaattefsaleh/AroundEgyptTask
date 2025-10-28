//
//  AppComponent.swift
//  AroundEgyptTask
//
//  Created by Marwa Attef on 28/10/2025.
//

import NeedleFoundation
import SwiftData
import FirebaseCrashlytics

protocol RemoteDataSourceProvidingProtocol {
    var experienceRemoteDataSource: ExperienceRemoteDataSourceProtocol { get }
}

protocol RepositoryProvidingProtocol {
    var experienceRepository: ExperienceRepositoryProtocol { get }
}

protocol FeatureBuilderProvidingProtocol {
    var HomeViewBuilder: HomeViewBuilder { get }
}

protocol AppComponentDependency: Dependency {}

class AppComponent: BootstrapComponent {
    var appConfiguration: AppConfigurationProtocol {
        shared { AppConfiguration() }
    }
    
    var modelContainer: ModelContainer {
        shared {
            do {
                let schema = Schema([ExperienceDBModel.self])
                let container = try ModelContainer(for: schema)
                return container
            } catch {
                Crashlytics.crashlytics().log("Failed to create ModelContainer: \(error)")
                fatalError("Failed to create ModelContainer: \(error)")
            }
        }
    }
    
   public var experienceModelActor: ExperienceModelActor {
        shared {
            ExperienceModelActor(modelContainer: modelContainer)
        }
    }
    
    public var networkService: NetworkServiceProtocol {
        NetworkService(config: appConfiguration)
    }
    
    public var networkMonitor: NetworkMonitorProtocol {
          shared {
              NetworkMonitor()
          }
      }
    
    var experienceUseCaseComponent: ExperienceUseCaseComponent {
        ExperienceUseCaseComponent(parent: self)
    }
    
    public var experienceUseCase: ExperienceUseCaseProtocol {
        experienceUseCaseComponent.useCase
    }
}

// Feature Builders
extension AppComponent: FeatureBuilderProvidingProtocol {
    var HomeViewBuilder: HomeViewBuilder {
         HomeComponent(parent: self)
     }
}
