//
//  HomeRouter.swift
//  AroundEgyptTask
//
//  Created by Marwa Attef on 28/10/2025.
//
import SwiftUI

protocol HomeRouterProtocol {
    func navigateToExperienceDetail(experience: Binding<ExperienceEntity>) -> ExperienceDetailsView
}

class HomeRouter: HomeRouterProtocol {
    private let homeComponent: HomeComponent
    
    init(homeComponent: HomeComponent) {
        self.homeComponent = homeComponent
    }
    
    func navigateToExperienceDetail(experience: Binding<ExperienceEntity>) -> ExperienceDetailsView {
        homeComponent.experienceDetailsBuilder.experienceDetailsView(experience: experience)
    }
}
