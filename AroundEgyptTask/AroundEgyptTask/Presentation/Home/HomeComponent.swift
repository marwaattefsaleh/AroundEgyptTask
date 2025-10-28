//
//  HomeComponent.swift
//  AroundEgyptTask
//
//  Created by Marwa Attef on 28/10/2025.
//

import NeedleFoundation

protocol HomeDependency: Dependency {
    var networkMonitor: NetworkMonitorProtocol { get }
    var experienceUseCase: ExperienceUseCaseProtocol { get }
}

protocol HomeViewBuilder {
    var homeView: HomeView { get }
}

class HomeComponent: Component<HomeDependency>, HomeViewBuilder {
    
    var homeRouter: HomeRouter {
        HomeRouter(homeComponent: self)
    }
    
    // MARK: - ViewModel (Swift 6 compatible)
    var homeViewModel: HomeViewModel {
        // Create on background thread first
        let useCase = dependency.experienceUseCase
        let router = self.homeRouter
        let networkMonitor = self.networkMonitor
        
        // Then move to MainActor
        return MainActor.assumeIsolated {
            HomeViewModel(
                experienceUseCase: useCase,
                router: router,
                networkMonitor: networkMonitor
            )
        }
    }
    
    // MARK: - View Builder
    var homeView: HomeView {
        HomeView(viewModel: self.homeViewModel)
    }
    
    var experienceDetailsBuilder: ExperienceDetailsViewBuilder {
        ExperienceDetailsComponent(parent: self)
    }
}
