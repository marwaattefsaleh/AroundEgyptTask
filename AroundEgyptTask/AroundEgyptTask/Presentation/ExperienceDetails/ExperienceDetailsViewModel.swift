//
//  ExperienceDetailsViewModel.swift
//  AroundEgyptTask
//
//  Created by Marwa Attef on 28/10/2025.
//
import Combine
import Foundation
import FirebaseCrashlytics

@MainActor
final class ExperienceDetailsViewModel: ObservableObject {
    @Published var showToast: Bool = false
    @Published  var experienceEntity: ExperienceEntity?
    @Published var isLoading: Bool = false
        
    private let experienceUseCase: ExperienceUseCaseProtocol
    private let networkMonitor: NetworkMonitorProtocol
    var toastMessage: String = ""
    
    init(experienceUseCase: ExperienceUseCaseProtocol, networkMonitor: NetworkMonitorProtocol) {
        self.experienceUseCase = experienceUseCase
        self.networkMonitor = networkMonitor
    }
    
    func getExperienceDetails(id: String) {
        isLoading = true
        Task {
            do {
                if let experienceEntity = try await self.experienceUseCase.getExperienceDetails(id: id, isOnline: networkMonitor.isConnected) {
                    self.experienceEntity = experienceEntity
                    isLoading = false
                }
            } catch {
                Crashlytics.crashlytics().log("getExperienceDetails: \(error.localizedDescription)")
                toastMessage = error.localizedDescription
                showToast = true
                isLoading = false

            }
        }
    }
    func likeExperience(id: String, onCompletion: @escaping (Bool) -> Void) {
        if experienceEntity?.isLiked ?? false {
            onCompletion(true)
            return }
        Task {
            do {
                let updatedLikesNo = try await self.experienceUseCase.likeExperience(id: id, isOnline: networkMonitor.isConnected)
                if let updatedLikesNo {
                    experienceEntity?.isLiked = true
                    experienceEntity?.likesNo = updatedLikesNo
                    onCompletion(true)
                } else {
                    // If nil, still call completion
                    onCompletion(false)
                }
            } catch {
                Crashlytics.crashlytics().log("likeExperience: \(error.localizedDescription)")

                toastMessage = error.localizedDescription
                showToast = true
                onCompletion(false)
            }
        }

    }
}
