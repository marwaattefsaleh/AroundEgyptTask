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
    
    init() {
        
        // Register Needle providers
        registerProviderFactories()
        
        // Initialize your root DI component
        appComponent = AppComponent()
    }
    
    var body: some Scene {
        WindowGroup {
            appComponent.HomeViewBuilder.homeView
        }
        .modelContainer(appComponent.modelContainer)
    }
}
