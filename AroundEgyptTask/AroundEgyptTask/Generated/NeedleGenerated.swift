

import FirebaseCrashlytics
import NeedleFoundation
import SwiftData
import SwiftUI

// swiftlint:disable unused_declaration
private let needleDependenciesHash : String? = nil

// MARK: - Traversal Helpers

private func parent1(_ component: NeedleFoundation.Scope) -> NeedleFoundation.Scope {
    return component.parent
}

private func parent2(_ component: NeedleFoundation.Scope) -> NeedleFoundation.Scope {
    return component.parent.parent
}

// MARK: - Providers

#if !NEEDLE_DYNAMIC

private class ExperienceUseCaseDependencye3e1d7fc6274e2b61cf1Provider: ExperienceUseCaseDependency {
    var networkService: NetworkServiceProtocol {
        return appComponent.networkService
    }
    var experienceModelActor: ExperienceModelActor {
        return appComponent.experienceModelActor
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->ExperienceUseCaseComponent
private func factory7eef91085b41acbfc489f47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return ExperienceUseCaseDependencye3e1d7fc6274e2b61cf1Provider(appComponent: parent1(component) as! AppComponent)
}
private class HomeDependency443c4e1871277bd8432aProvider: HomeDependency {
    var networkMonitor: NetworkMonitorProtocol {
        return appComponent.networkMonitor
    }
    var experienceUseCase: ExperienceUseCaseProtocol {
        return appComponent.experienceUseCase
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->HomeComponent
private func factory67229cdf0f755562b2b1f47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return HomeDependency443c4e1871277bd8432aProvider(appComponent: parent1(component) as! AppComponent)
}
private class ExperienceDetailsDependencyc0c87e8e8cfa543775f7Provider: ExperienceDetailsDependency {
    var networkMonitor: NetworkMonitorProtocol {
        return appComponent.networkMonitor
    }
    var experienceUseCase: ExperienceUseCaseProtocol {
        return appComponent.experienceUseCase
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->HomeComponent->ExperienceDetailsComponent
private func factoryde90cacc8c9d9fa6757cb7304b634b3e62c64b3c(_ component: NeedleFoundation.Scope) -> AnyObject {
    return ExperienceDetailsDependencyc0c87e8e8cfa543775f7Provider(appComponent: parent2(component) as! AppComponent)
}

#else
extension ExperienceUseCaseComponent: NeedleFoundation.Registration {
    public func registerItems() {
        keyPathToName[\ExperienceUseCaseDependency.networkService] = "networkService-NetworkServiceProtocol"
        keyPathToName[\ExperienceUseCaseDependency.experienceModelActor] = "experienceModelActor-ExperienceModelActor"
    }
}
extension AppComponent: NeedleFoundation.Registration {
    public func registerItems() {

        localTable["experienceModelActor-ExperienceModelActor"] = { [unowned self] in self.experienceModelActor as Any }
        localTable["networkService-NetworkServiceProtocol"] = { [unowned self] in self.networkService as Any }
        localTable["networkMonitor-NetworkMonitorProtocol"] = { [unowned self] in self.networkMonitor as Any }
        localTable["experienceUseCase-ExperienceUseCaseProtocol"] = { [unowned self] in self.experienceUseCase as Any }
    }
}
extension HomeComponent: NeedleFoundation.Registration {
    public func registerItems() {
        keyPathToName[\HomeDependency.networkMonitor] = "networkMonitor-NetworkMonitorProtocol"
        keyPathToName[\HomeDependency.experienceUseCase] = "experienceUseCase-ExperienceUseCaseProtocol"

    }
}
extension ExperienceDetailsComponent: NeedleFoundation.Registration {
    public func registerItems() {
        keyPathToName[\ExperienceDetailsDependency.networkMonitor] = "networkMonitor-NetworkMonitorProtocol"
        keyPathToName[\ExperienceDetailsDependency.experienceUseCase] = "experienceUseCase-ExperienceUseCaseProtocol"
    }
}


#endif

private func factoryEmptyDependencyProvider(_ component: NeedleFoundation.Scope) -> AnyObject {
    return EmptyDependencyProvider(component: component)
}

// MARK: - Registration
private func registerProviderFactory(_ componentPath: String, _ factory: @escaping (NeedleFoundation.Scope) -> AnyObject) {
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: componentPath, factory)
}

#if !NEEDLE_DYNAMIC

@inline(never) private func register1() {
    registerProviderFactory("^->AppComponent->ExperienceUseCaseComponent", factory7eef91085b41acbfc489f47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent", factoryEmptyDependencyProvider)
    registerProviderFactory("^->AppComponent->HomeComponent", factory67229cdf0f755562b2b1f47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->HomeComponent->ExperienceDetailsComponent", factoryde90cacc8c9d9fa6757cb7304b634b3e62c64b3c)
}
#endif

public func registerProviderFactories() {
#if !NEEDLE_DYNAMIC
    register1()
#endif
}
