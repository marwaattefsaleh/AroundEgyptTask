//
//  ExperienceLocalDataSource.swift
//  AroundEgyptTask
//
//  Created by Marwa Attef on 28/10/2025.
//

import SwiftData
import Foundation

protocol ExperienceLocalDataSourceProtocol {
    func getRecommendedExperiences() async throws -> [ExperienceDBModel]
    func getRecentExperiences() async throws -> [ExperienceDBModel]
    func getExperienceDetails(by id: String) async throws -> ExperienceDBModel
    func saveExperiences(items: [ExperienceDBModel]) async throws
    func searchExperiences(by searchText: String) async throws -> [ExperienceDBModel]
    func likeExperience(id: String) async throws -> ExperienceDBModel?
}

class ExperienceLocalDataSource: ExperienceLocalDataSourceProtocol {
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext
    
    init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
        self.modelContext = ModelContext(modelContainer)
    }
    
    func getRecommendedExperiences() async throws -> [ExperienceDBModel] {
        let descriptor = FetchDescriptor<ExperienceDBModel>(
            predicate: #Predicate { $0.isRecommended == true },
            sortBy: [SortDescriptor(\.order, order: .forward)]
        )
        
        let results: [ExperienceDBModel]
        do {
            results = try modelContext.fetch(descriptor)
        } catch {
            throw DatabaseError.fetchFailed(error)
        }
        
        guard !results.isEmpty else {
            throw DatabaseError.notFound
        }
        
        return results
    }
    func getRecentExperiences() async throws -> [ExperienceDBModel] {
        let descriptor = FetchDescriptor<ExperienceDBModel>(
            predicate: #Predicate { $0.isRecent == true },
            sortBy: [SortDescriptor(\.order, order: .forward)] // or .reverse if needed
        )
        do {
            let results = try modelContext.fetch(descriptor)
            return results
        } catch {
            throw DatabaseError.fetchFailed(error)
        }
    }
    
    func getExperienceDetails(by id: String) async throws -> ExperienceDBModel {
        let descriptor = FetchDescriptor<ExperienceDBModel>(
            predicate: #Predicate { $0.id == id }
        )
        
        do {
            let results = try modelContext.fetch(descriptor)
            guard let experience = results.first else {
                throw DatabaseError.notFound
            }
            return experience
        } catch let error as DatabaseError {
            // propagate DatabaseError.notFound correctly
            throw error
        } catch {
            throw DatabaseError.fetchFailed(error)
        }
    }
    
    func saveExperiences(items: [ExperienceDBModel]) async throws {
        let descriptor = FetchDescriptor<ExperienceDBModel>()
        
        do {
            // Fetch existing experiences
            let existingExperiences = try modelContext.fetch(descriptor)
            
            // Create lookup maps
            let existingById = Dictionary(uniqueKeysWithValues: existingExperiences.map { ($0.id, $0) })
            let newIds = Set(items.map { $0.id })
            
            // Update or insert
            for (index, item) in items.enumerated() {
                if let existing = existingById[item.id] {
                    existing.title = item.title
                    existing.desc = item.desc
                    existing.coverPhoto = item.coverPhoto
                    existing.isRecommended = item.isRecommended
                    existing.isLiked = item.isLiked
                    existing.isRecent = item.isRecent
                    existing.cityName = item.cityName
                    existing.likesNo = item.likesNo
                    existing.viewsNo = item.viewsNo
                    existing.order = index  // keep order
                    
                } else {
                    item.order = index      // keep order for new inserts
                    modelContext.insert(item)
                }
            }
            
            // Delete records that no longer exist in new data
            for existing in existingExperiences where !newIds.contains(existing.id) {
                modelContext.delete(existing)
            }
            
            // Save changes
            try modelContext.save()
            
        } catch {
            throw DatabaseError.saveFailed(error)
        }
    }
    func searchExperiences(by searchText: String) async throws -> [ExperienceDBModel] {
        let descriptor = FetchDescriptor<ExperienceDBModel>(
            predicate: #Predicate { experience in
                experience.title.localizedStandardContains(searchText)
            },
            sortBy: [SortDescriptor(\.order, order: .forward)]
        )
        
        do {
            let results = try modelContext.fetch(descriptor)
            guard !results.isEmpty else {
                throw DatabaseError.notFound
            }
            return results
        } catch {
            throw DatabaseError.fetchFailed(error)
        }
    }
    
    func likeExperience(id: String) async throws -> ExperienceDBModel? {
        let descriptor = FetchDescriptor<ExperienceDBModel>(
            predicate: #Predicate { $0.id == id }
        )
        do {
            let results = try modelContext.fetch(descriptor)
            guard let experience = results.first else {
                throw DatabaseError.notFound
            }
            
            // Update the like status
            experience.isLiked = true
            
            // Save the changes
            try modelContext.save()
            
            return experience
            
        } catch {
            throw DatabaseError.updateFailed(error)
        }
    }
}
