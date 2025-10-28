//
//  ExperienceModelActor.swift
//  AroundEgyptTask
//
//  Created by Marwa Attef on 28/10/2025.
//

import SwiftData
import Foundation

// MARK: - Experience Model Actor
// This actor is responsible for all SwiftData operations related to ExperienceDBModel.
// Using @ModelActor ensures thread-safe access to modelContext.
@ModelActor
actor ExperienceModelActor {
    // MARK: - Fetch Recommended Experiences
    /// Fetches experiences marked as recommended from the database.
    /// - Throws: DatabaseError.notFound if no recommended experiences exist.
    /// - Throws: DatabaseError.fetchFailed if any unexpected database error occurs.
    /// - Returns: Array of ExperienceEntity objects
    func getRecommendedExperiences() throws -> [ExperienceEntity] {
        let descriptor = FetchDescriptor<ExperienceDBModel>(
            predicate: #Predicate { $0.isRecommended == true },
            sortBy: [SortDescriptor(\.order, order: .forward)]
        )
        
        do {
            let results = try modelContext.fetch(descriptor)
            guard !results.isEmpty else {
                throw DatabaseError.notFound  // propagate as-is
            }
            return results.map { $0.toEntity() }
        } catch let error as DatabaseError {
            throw error
        } catch {
            throw DatabaseError.fetchFailed(error)  // wrap unexpected errors
        }
    }
    
    // MARK: - Fetch Recent Experiences
    /// Fetches experiences marked as recent.
    func getRecentExperiences() throws -> [ExperienceEntity] {
        let descriptor = FetchDescriptor<ExperienceDBModel>(
            predicate: #Predicate { $0.isRecent == true },
            sortBy: [SortDescriptor(\.order, order: .forward)]
        )
        
        do {
            return try modelContext.fetch(descriptor).map { $0.toEntity()}
        } catch {
            throw DatabaseError.fetchFailed(error)
        }
    }
    
    // MARK: - Get Experience Details
    /// Fetches a single experience by its ID.
    /// - Throws: DatabaseError.notFound if the ID does not exist.
    /// - Throws: DatabaseError.fetchFailed for unexpected errors.
    func getExperienceDetails(by id: String) throws -> ExperienceEntity {
        let descriptor = FetchDescriptor<ExperienceDBModel>(
            predicate: #Predicate { $0.id == id }
        )
        
        do {
            let results = try modelContext.fetch(descriptor)
            guard let experience = results.first else {
                throw DatabaseError.notFound
            }
            return experience.toEntity()
        } catch let dbError as DatabaseError {
            throw dbError
        } catch {
            throw DatabaseError.fetchFailed(error)
        }
    }
    
    // MARK: - Save or Update Single Experience
    /// Inserts or updates a single ExperienceDBModel in the database.
    /// Updates fields if record exists; inserts a new record otherwise.
    func saveOrUpdateExperience(_ item: ExperienceDBModel) throws {
        let id  = item.id
        let descriptor = FetchDescriptor<ExperienceDBModel>(
            predicate: #Predicate { $0.id == id }
        )
        
        do {
            let results = try modelContext.fetch(descriptor)
            
            if let existing = results.first {
                print("🔄 UPDATING existing experience: \(item.id) - \(item.title)")
                // Update existing record
                existing.title = item.title
                existing.desc = item.desc
                existing.coverPhoto = item.coverPhoto
                existing.isRecommended = item.isRecommended
                existing.cityName = item.cityName
                existing.likesNo = item.likesNo
                existing.viewsNo = item.viewsNo
            } else {
                print("🆕 INSERTING new experience: \(item.id) - \(item.title)")
                // Insert a new managed instance
                
                modelContext.insert(item)
            }
            
            try modelContext.save()
            print("✅ Single item save/update completed successfully")
            
        } catch let dbError as DatabaseError {
            throw dbError
        } catch {
            print("❌ Single item save failed: \(error)")
            throw DatabaseError.saveFailed(error)
        }
    }
    
    // MARK: - Save Experiences (Upsert + Delete Old)
    /// Saves a batch of experiences.
    /// Updates existing records, inserts new ones, and deletes old ones based on flags.
    func saveExperiences(
        items: [ExperienceDBModel],
        isRecommended: Bool = false,
        isRecent: Bool = false
    ) throws {
        do {
            let existingExperiences = try modelContext.fetch(FetchDescriptor<ExperienceDBModel>())
            
            // DEBUG: Check for duplicates
            print("=== DEBUG START ===")
            print("Total existing records: \(existingExperiences.count)")
            
            let ids = existingExperiences.map { $0.id }
            let uniqueIds = Set(ids)
            print("Unique IDs: \(uniqueIds.count), Total IDs: \(ids.count)")
            
            // Check for duplicates
            let duplicates = Dictionary(grouping: existingExperiences, by: { $0.id })
                .filter { $0.value.count > 1 }
            
            if !duplicates.isEmpty {
                print("🚨 DUPLICATE FOUND:")
                for (id, experiences) in duplicates {
                    print("   ID: \(id) - Count: \(experiences.count)")
                    for exp in experiences {
                        print("     - Title: \(exp.title), isRecommended: \(exp.isRecommended), isRecent: \(exp.isRecent)")
                    }
                }
            }
            print("=== DEBUG END ===")
            
            let existingById = Dictionary(uniqueKeysWithValues: existingExperiences.map { ($0.id, $0) })
            let newIds = Set(items.map { $0.id })
            
            print("New items count: \(items.count)")
            print("Existing in DB count: \(existingById.count)")
            print("isRecommended: \(isRecommended), isRecent: \(isRecent)")
            
            for (index, item) in items.enumerated() {
                if let existing = existingById[item.id] {
                    print("🔄 UPDATING: \(item.id) - \(item.title)")
                    // Update existing record
                    existing.title = item.title
                    existing.desc = item.desc
                    existing.coverPhoto = item.coverPhoto
                    existing.isRecommended = item.isRecommended
                    existing.isRecent = item.isRecent
                    existing.cityName = item.cityName
                    existing.likesNo = item.likesNo
                    existing.viewsNo = item.viewsNo
                    existing.order = index
                } else {
                    print("🆕 INSERTING: \(item.id) - \(item.title)")
                    // Insert new record
                    item.order = index
                    modelContext.insert(item)
                }
            }
            
            // Delete old records based on flags
            var toDelete: [ExperienceDBModel] = []
            
            if isRecommended {
                let recommendedToDelete = existingExperiences.filter {
                    $0.isRecommended && !newIds.contains($0.id)
                }
                toDelete.append(contentsOf: recommendedToDelete)
                print("🗑️ Marked \(recommendedToDelete.count) OLD recommended records for deletion")
            }
            
            if isRecent {
                let recentToDelete = existingExperiences.filter {
                    $0.isRecent && !newIds.contains($0.id)
                }
                toDelete.append(contentsOf: recentToDelete)
                print("🗑️ Marked \(recentToDelete.count) OLD recent records for deletion")
            }
            
            // Remove duplicates in case both flags are true and same record matches both conditions
            toDelete = Array(Set(toDelete))
            
            print("🗑️ Deleting \(toDelete.count) total old records")
            for existing in toDelete {
                print("   Deleting: \(existing.id) - \(existing.title) [Recommended: \(existing.isRecommended), Recent: \(existing.isRecent)]")
                modelContext.delete(existing)
            }
            
            try modelContext.save()
            print("✅ Save completed successfully")
            
        } catch {
            print("❌ Save failed: \(error)")
            throw DatabaseError.saveFailed(error)
        }
    }
    // MARK: - Search Experiences
    /// Search experiences by title text
    func searchExperiences(by searchText: String) throws -> [ExperienceEntity] {
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
            return results.map { $0.toEntity()}
        } catch {
            throw DatabaseError.fetchFailed(error)
        }
    }
    
    
    // MARK: - Like Experience
    /// Increment likes for a given experience ID and mark as liked
    func likeExperience(id: String, likesNo: Int) throws -> ExperienceEntity? {
        let descriptor = FetchDescriptor<ExperienceDBModel>(
            predicate: #Predicate { $0.id == id }
        )
        
        do {
            let results = try modelContext.fetch(descriptor)
            guard let experience = results.first else {
                throw DatabaseError.notFound
            }
            experience.likesNo = likesNo
            experience.isLiked = true
            try modelContext.save()
            return experience.toEntity()
            
        } catch {
            throw DatabaseError.updateFailed(error)
        }
    }
}
