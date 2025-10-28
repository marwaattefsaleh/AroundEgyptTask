//
//  ExperienceDetailsComponent.swift
//  AroundEgyptTask
//
//  Created by Marwa Attef on 28/10/2025.
//
import NeedleFoundation
import SwiftUI

protocol ExperienceDetailsDependency: Dependency {
    var networkMonitor: NetworkMonitorProtocol { get }
    var experienceUseCase: ExperienceUseCaseProtocol { get }
}

protocol ExperienceDetailsViewBuilder {
    func experienceDetailsView(experience: Binding<ExperienceEntity>) -> ExperienceDetailsView
}

class ExperienceDetailsComponent: Component<ExperienceDetailsDependency>, ExperienceDetailsViewBuilder {
    
    // MARK: - ViewModel (Swift 6 compatible)
    var experienceDetailsViewModel: ExperienceDetailsViewModel {
        let useCase = dependency.experienceUseCase
        let networkMonitor = self.networkMonitor
        
        return MainActor.assumeIsolated {
            ExperienceDetailsViewModel(
                experienceUseCase: useCase,
                networkMonitor: networkMonitor
            )
        }
    }
    
    // MARK: - View Builder
    func experienceDetailsView(experience: Binding<ExperienceEntity>) -> ExperienceDetailsView {
        ExperienceDetailsView(
            viewModel: self.experienceDetailsViewModel,
            experience: experience
        )
    }
}
