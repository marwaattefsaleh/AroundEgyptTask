//
//  AroundEgyptTaskApp.swift
//  AroundEgyptTask
//
//  Created by Marwa Attef on 28/10/2025.
//

import SwiftUI
import SwiftData

@main
struct AroundEgyptTaskApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var appComponent: AppComponent!
    var homeView: HomeView!

    init() {
        // Register Needle providers
        registerProviderFactories()
        appComponent = AppComponent()

        if CommandLine.arguments.contains("--UITestMode") {
            // Create mock VM
            let mockVM = HomeViewModel(experienceUseCase: MockExperienceUseCase(), router: MockHomeRouter(), networkMonitor: MockNetworkMonitor())
            mockVM.recommendedExperienceEntityList = [
                ExperienceEntity(
                    id: "7f209d18-36a1-44d5-a0ed-b7eddfad48d6",
                    title: "Test Experience",
                    desc: "Ancient site",
                    coverPhoto: nil,
                    likesNo: 0,
                    viewsNo: 0,
                    isRecommended: true,
                    isRecent: false,
                    isLiked: false,
                    cityName: "Cairo",
                    order: 0
                )
            ]
            mockVM.recentExperienceEntityList = []
            print("hhhhh\(mockVM.recommendedExperienceEntityList.count)")
            // Initialize HomeView directly with mock VM
            homeView = HomeView(viewModel: mockVM)
        } else {
            homeView = appComponent.HomeViewBuilder.homeView
        }
        
    }
    
    var body: some Scene {
        WindowGroup {
       homeView
        }
        .modelContainer(appComponent.modelContainer)
    }
}
