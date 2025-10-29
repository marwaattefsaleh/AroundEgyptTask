//
//  MockHomeRouter.swift
//  AroundEgyptTask
//
//  Created by Marwa Attef on 28/10/2025.
//
import Foundation
import Alamofire
import SwiftUI
@testable import AroundEgyptTask

class MockHomeRouter: HomeRouterProtocol {
    private(set) var navigateCalled = false
    private(set) var passedExperience: ExperienceEntity?

    @MainActor func navigateToExperienceDetail(experience: Binding<ExperienceEntity>) -> ExperienceDetailsView {
        navigateCalled = true
        passedExperience = experience.wrappedValue
        
        // Provide a mock ExperienceDetailsView with dummy dependencies
        let mockViewModel = ExperienceDetailsViewModel(
            experienceUseCase: MockExperienceUseCase(),
            networkMonitor: MockNetworkMonitor()
        )
        return ExperienceDetailsView(viewModel: mockViewModel, experience: experience)
    }
}
