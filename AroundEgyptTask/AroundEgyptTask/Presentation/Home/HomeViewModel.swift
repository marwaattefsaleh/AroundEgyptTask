//
//  HomeViewModel.swift
//  AroundEgyptTask
//
//  Created by Marwa Attef on 28/10/2025.
//
import Combine
import Foundation
import SwiftUI
import FirebaseCrashlytics
@MainActor
final class HomeViewModel: ObservableObject {
    @Published var showToast: Bool = false
    @Published  var recommendedExperienceEntityList: [ExperienceEntity] = []
    @Published  var recentExperienceEntityList: [ExperienceEntity] = []

    @Published var isLoadingRecommended: Bool = false
    @Published var isLoadingRecent: Bool = false

    @Published var isFromSearch: Bool = false

    private let experienceUseCase: ExperienceUseCaseProtocol
    private let router: HomeRouterProtocol
    private let networkMonitor: NetworkMonitorProtocol
    var toastMessage: String = ""
    
    init(experienceUseCase: ExperienceUseCaseProtocol,
         router: HomeRouterProtocol, networkMonitor: NetworkMonitorProtocol) {
        self.experienceUseCase = experienceUseCase
        self.router = router
        self.networkMonitor = networkMonitor
    }
    
    func getData() {
        isLoadingRecent = true
        isLoadingRecommended = true
        isFromSearch = false
        getRecommendedExperiences()
        getRecentExperiences()
    }
    
    func getRecommendedExperiences() {
        Task {
            do {
                recommendedExperienceEntityList = try await  self.experienceUseCase.getRecommendedExperiences(isOnline: networkMonitor.isConnected)
                isLoadingRecommended = false
            } catch {
                Crashlytics.crashlytics().log("getRecommendedExperiences: \(error.localizedDescription)")

                toastMessage = error.localizedDescription
                showToast = true
                isLoadingRecommended = false

            }
        }
    }
    
    func getRecentExperiences() {
        Task {
            do {
                recentExperienceEntityList = try await  self.experienceUseCase.getRecentExperiences(isOnline: networkMonitor.isConnected)
                isLoadingRecent = false

            } catch {
                Crashlytics.crashlytics().log("getRecentExperiences: \(error.localizedDescription)")

                toastMessage = error.localizedDescription
                showToast = true
                isLoadingRecent = false

            }
        }
    }
    
    func performSearch(searchText: String) {
        isFromSearch = true
        isLoadingRecent = true
        Task {
            do {
                recentExperienceEntityList = try await  self.experienceUseCase.searchExperience(by: searchText, isOnline: networkMonitor.isConnected)
                isLoadingRecent = false

            } catch {
                Crashlytics.crashlytics().log("performSearch: \(error.localizedDescription)")
                toastMessage = error.localizedDescription
                showToast = true
                isLoadingRecent = false
            }
        }
    }
    
    func likeExperience(id: String) {
        Task {
            do {
                if let updatedLikesNo = try await self.experienceUseCase.likeExperience(id: id, isOnline: networkMonitor.isConnected) {
                    
                    if let index = recommendedExperienceEntityList.firstIndex(where: { $0.id == id }) {
                        recommendedExperienceEntityList[index].isLiked = true
                        recommendedExperienceEntityList[index].likesNo = updatedLikesNo
                    }
                    
                    // Update recent list
                    if let index = recentExperienceEntityList.firstIndex(where: { $0.id == id }) {
                        recentExperienceEntityList[index].isLiked = true
                        recentExperienceEntityList[index].likesNo = updatedLikesNo
                    }
                }
            } catch {
                Crashlytics.crashlytics().log("likeExperience: \(error.localizedDescription)")
                toastMessage = error.localizedDescription
                showToast = true
            }
        }
    }
    
    func navigateToDetail(experience: Binding<ExperienceEntity>) -> ExperienceDetailsView {
        router.navigateToExperienceDetail(experience: experience)
    }
    
  
}
