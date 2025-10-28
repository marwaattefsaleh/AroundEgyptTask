//
//  ExperienceLocalDataSourceTests.swift
//  AroundEgyptTask
//
//  Created by Marwa Attef on 28/10/2025.
//

import XCTest
import SwiftData
@testable import AroundEgyptTask
@MainActor
class ExperienceLocalDataSourceTests: XCTestCase {

    private var sut: ExperienceLocalDataSource!
    private var modelContainer: ModelContainer!
    private var actor: ExperienceModelActor!

    override func setUpWithError() throws {
        let schema = Schema([ExperienceDBModel.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        modelContainer = try ModelContainer(for: schema, configurations: [config])
        actor = ExperienceModelActor(modelContainer: modelContainer)
        sut = ExperienceLocalDataSource(actor: actor)
    }

    override func tearDownWithError() throws {
        sut = nil
        actor = nil
        modelContainer = nil
    }

    // MARK: - Helper to create ExperienceDBModel
    private func makeExperience(
        id: String = UUID().uuidString,
        title: String = "Test",
        desc: String = "Desc",
        coverPhoto: String? = nil,
        likesNo: Int = 0,
        viewsNo: Int = 0,
        isRecommended: Bool = true,
        isRecent: Bool = false,
        isLiked: Bool = false,
        cityName: String? = "Cairo",
        order: Int = 0
    ) -> ExperienceDBModel {
        let exp = ExperienceDBModel(
            id: id,
            title: title,
            desc: desc,
            coverPhoto: coverPhoto,
            likesNo: likesNo,
            viewsNo: viewsNo,
            isRecommended: isRecommended,
            isRecent: isRecent,
            isLiked: isLiked,
            cityName: cityName
        )
        exp.order = order
        return exp
    }
    //
    
    func test_getRecommendedExperiences_emptyDatabase_throwsNotFound() async throws {
        do {
            _ = try await sut.getRecommendedExperiences()
            XCTFail("Expected getRecommendedExperiences to throw DatabaseError.notFound")
        } catch let error as DatabaseError {
            switch error {
            case .notFound:
                break // ✅ expected
            default:
                XCTFail("Unexpected DatabaseError case: \(error)")
            }
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }

    func test_getRecommendedExperiences_allRecommended_returnsAll() async throws {
        let items = [
            makeExperience(id: "1", isRecommended: true, order: 0),
            makeExperience(id: "2", isRecommended: true, order: 1)
        ]
        try await sut.saveExperiences(items: items, isRecommended: true, isRecent: false)

        let results = try await sut.getRecommendedExperiences()
        XCTAssertEqual(results.count, 2)
        XCTAssertTrue(results.allSatisfy { $0.isRecommended })
        XCTAssertEqual(results.map { $0.id }, ["1", "2"])
    }

    func test_getRecommendedExperiences_mixedRecommendedAndNonRecommended_returnsOnlyRecommended() async throws {
        let items = [
            makeExperience(id: "1", isRecommended: true, order: 0),
            makeExperience(id: "2", isRecommended: false, order: 1),
            makeExperience(id: "3", isRecommended: true, order: 2)
        ]
        try await sut.saveExperiences(items: items, isRecommended: true, isRecent: false)

        let results = try await sut.getRecommendedExperiences()
        XCTAssertEqual(results.count, 2)
        XCTAssertTrue(results.allSatisfy { $0.isRecommended })
        XCTAssertEqual(results.map { $0.id }, ["1", "3"])
    }

    func test_getRecommendedExperiences_orderIsPreserved() async throws {
        let items = [
            makeExperience(id: "1", isRecommended: true, order: 2),
            makeExperience(id: "2", isRecommended: true, order: 0),
            makeExperience(id: "3", isRecommended: true, order: 1)
        ]
        try await sut.saveExperiences(items: items, isRecommended: true, isRecent: false)

        let results = try await sut.getRecommendedExperiences()
        // `saveExperiences` overwrites .order according to array index
        let expectedOrder = ["1", "2", "3"]
        XCTAssertEqual(results.map { $0.id }, expectedOrder)
    }
    //
    func test_getRecentExperiences_emptyDatabase_returnsEmpty() async throws {
        let results = try await sut.getRecentExperiences()
        XCTAssertTrue(results.isEmpty)
    }

    func test_getRecentExperiences_allRecent_returnsAll() async throws {
        let items = [
            makeExperience(id: "1", isRecent: true, order: 0),
            makeExperience(id: "2", isRecent: true, order: 1)
        ]
        try await sut.saveExperiences(items: items, isRecommended: false, isRecent: true)

        let results = try await sut.getRecentExperiences()
        XCTAssertEqual(results.count, 2)
        XCTAssertEqual(results[0].id, "1")
        XCTAssertEqual(results[1].id, "2")
    }

    func test_getRecentExperiences_mixedRecentAndNonRecent_returnsOnlyRecent() async throws {
        let items = [
            makeExperience(id: "1", isRecent: true, order: 0),
            makeExperience(id: "2", isRecent: false, order: 1),
            makeExperience(id: "3", isRecent: true, order: 2)
        ]
        try await sut.saveExperiences(items: items, isRecommended: false, isRecent: true)

        let results = try await sut.getRecentExperiences()
        XCTAssertEqual(results.count, 2)
        XCTAssertTrue(results.allSatisfy { $0.isRecent })
        XCTAssertEqual(results.map { $0.id }, ["1", "3"])
    }

    func test_getRecentExperiences_orderIsPreserved() async throws {
        let items = [
            makeExperience(id: "1", isRecent: true, order: 2),
            makeExperience(id: "2", isRecent: true, order: 0),
            makeExperience(id: "3", isRecent: true, order: 1)
        ]
        try await sut.saveExperiences(items: items, isRecommended: false, isRecent: true)

        let results = try await sut.getRecentExperiences()
        let expectedOrder = ["1", "2", "3"] // according to .order property
        XCTAssertEqual(results.map { $0.id }, expectedOrder)
    }

    func test_getRecentExperiences_afterUpdatingItems_reflectsChanges() async throws {
        let items = [
            makeExperience(id: "1", isRecent: true, order: 0)
        ]
        try await sut.saveExperiences(items: items, isRecommended: false, isRecent: true)

        var results = try await sut.getRecentExperiences()
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results[0].id, "1")

        // Update existing item
        let updated = makeExperience(id: "1", isRecent: false)
        try await sut.saveExperiences(items: [updated], isRecommended: false, isRecent: true)

        results = try await sut.getRecentExperiences()
        XCTAssertTrue(results.isEmpty)
    }
    
/////
   func test_getExperienceDetails_existingId_returnsCorrectExperience() async throws {
    let experience = makeExperience(id: "1", title: "Pyramids Tour")
    try await sut.saveOrUpdateExperience(experience)

    let result = try await sut.getExperienceDetails(by: "1")
    XCTAssertEqual(result.id, "1")
    XCTAssertEqual(result.title, "Pyramids Tour")
    XCTAssertEqual(result.order, 0)
}

func test_getExperienceDetails_nonExistingId_throwsNotFound() async throws {
    let experience = makeExperience(id: "1", title: "Pyramids Tour")
    try await sut.saveOrUpdateExperience(experience)

    do {
        _ = try await sut.getExperienceDetails(by: "invalid_id")
        XCTFail("Expected getExperienceDetails to throw DatabaseError.notFound")
    } catch let error as DatabaseError {
        switch error {
        case .notFound:
            break // ✅ expected
        default:
            XCTFail("Unexpected DatabaseError case: \(error)")
        }
    } catch {
        XCTFail("Unexpected error type: \(error)")
    }
}

func test_getExperienceDetails_multipleItems_returnsCorrectOne() async throws {
    let items = [
        makeExperience(id: "1", title: "Pyramids"),
        makeExperience(id: "2", title: "Nile Cruise"),
        makeExperience(id: "3", title: "Luxor Tour")
    ]
    try await sut.saveExperiences(items: items, isRecommended: true, isRecent: false)

    let result = try await sut.getExperienceDetails(by: "2")
    XCTAssertEqual(result.id, "2")
    XCTAssertEqual(result.title, "Nile Cruise")
}

func test_getExperienceDetails_afterUpdate_returnsUpdatedData() async throws {
    let experience = makeExperience(id: "1", title: "Old Title")
    try await sut.saveOrUpdateExperience(experience)

    let updated = makeExperience(id: "1", title: "New Title")
    try await sut.saveOrUpdateExperience(updated)

    let result = try await sut.getExperienceDetails(by: "1")
    XCTAssertEqual(result.title, "New Title")
}

func test_getExperienceDetails_emptyDatabase_throwsNotFound() async throws {
    do {
        _ = try await sut.getExperienceDetails(by: "any_id")
        XCTFail("Expected getExperienceDetails to throw DatabaseError.notFound")
    } catch let error as DatabaseError {
        switch error {
        case .notFound:
            break
        default:
            XCTFail("Unexpected DatabaseError case: \(error)")
        }
    } catch {
        XCTFail("Unexpected error type: \(error)")
    }
}
    ///
    func test_saveExperiences_insertsNewItems() async throws {
        let items = [
            makeExperience(id: "1", title: "Pyramids Tour"),
            makeExperience(id: "2", title: "Nile Cruise")
        ]

        try await sut.saveExperiences(items: items, isRecommended: true, isRecent: false)

        let descriptor = FetchDescriptor<ExperienceDBModel>()
        let saved = try modelContainer.mainContext.fetch(descriptor) // ✅ OK because @MainActor
        XCTAssertEqual(saved.count, 2)
    }
    @MainActor
    func test_saveExperiences_updatesExistingItems() async throws {
        let original = makeExperience(id: "1", title: "Old Title", likesNo: 0, order: 0)
        try await sut.saveOrUpdateExperience(original)

        let updated = makeExperience(id: "1", title: "New Title", likesNo: 10, order: 0)
        try await sut.saveOrUpdateExperience(updated)

        let descriptor = FetchDescriptor<ExperienceDBModel>()
        let saved = try modelContainer.mainContext.fetch(descriptor)
        XCTAssertEqual(saved.count, 1)
        XCTAssertEqual(saved[0].title, "New Title")
        XCTAssertEqual(saved[0].likesNo, 10)
    }
   
    func test_saveExperiences_preservesOrder() async throws {
        let items = [
            makeExperience(id: "1", title: "First"),
            makeExperience(id: "2", title: "Second"),
            makeExperience(id: "3", title: "Third")
        ]
        try await sut.saveExperiences(items: items, isRecommended: true, isRecent: true)

        let descriptor = FetchDescriptor<ExperienceDBModel>(
            sortBy: [SortDescriptor(\.order, order: .forward)]
        )
        let saved = try modelContainer.mainContext.fetch(descriptor)
        XCTAssertEqual(saved.map { $0.id }, ["1", "2", "3"])
        XCTAssertEqual(saved.map { $0.order }, [0, 1, 2])
    }

    func test_saveExperiences_deletesRemovedItems() async throws {
        let initial = [
            makeExperience(id: "1", title: "One"),
            makeExperience(id: "2", title: "Two")
        ]
        try await sut.saveExperiences(items: initial, isRecommended: true, isRecent: false)

        let updated = [
            makeExperience(id: "2", title: "Two Updated"),
            makeExperience(id: "3", title: "Three")
        ]
        try await sut.saveExperiences(items: updated, isRecommended: true, isRecent: false)

        let descriptor = FetchDescriptor<ExperienceDBModel>()
        let saved = try modelContainer.mainContext.fetch(descriptor)
        XCTAssertEqual(saved.count, 2)
        XCTAssertFalse(saved.contains(where: { $0.id == "1" }))
        XCTAssertTrue(saved.contains(where: { $0.id == "2" }))
        XCTAssertTrue(saved.contains(where: { $0.id == "3" }))

        let two = saved.first { $0.id == "2" }!
        XCTAssertEqual(two.title, "Two Updated")
    }
    
    func test_saveExperiences_multipleUpdatesAndInserts() async throws {
        let initial = [
            makeExperience(id: "1", title: "One"),
            makeExperience(id: "2", title: "Two")
        ]
        try await sut.saveExperiences(items: initial, isRecommended: true, isRecent: false)

        let updated = [
            makeExperience(id: "2", title: "Two Updated"),
            makeExperience(id: "3", title: "Three"),
            makeExperience(id: "4", title: "Four")
        ]
        try await sut.saveExperiences(items: updated, isRecommended: true, isRecent: false)

        let descriptor = FetchDescriptor<ExperienceDBModel>(
            sortBy: [SortDescriptor(\.order, order: .forward)]
        )
        let saved = try modelContainer.mainContext.fetch(descriptor)
        XCTAssertEqual(saved.count, 3)
        XCTAssertEqual(saved.map { $0.id }, ["2", "3", "4"])
        XCTAssertEqual(saved.map { $0.title }, ["Two Updated", "Three", "Four"])
        XCTAssertEqual(saved.map { $0.order }, [0, 1, 2])
    }
    // MARK: - Tests for searchExperiences(by:)

    func test_searchExperiences_returnsMatchingItem() async throws {
        let item = makeExperience(id: "1", title: "Pyramids Tour", order: 0)
        try await sut.saveOrUpdateExperience(item)

        let results = try await sut.searchExperiences(by: "Pyramids")
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.id, "1")
    }

    func test_searchExperiences_returnsMultipleMatchingItems() async throws {
        let items = [
            makeExperience(id: "1", title: "Pyramids Tour", order: 0),
            makeExperience(id: "2", title: "Pyramids Adventure", order: 1),
            makeExperience(id: "3", title: "Nile Cruise", order: 2)
        ]
        try await sut.saveExperiences(items: items, isRecommended: true, isRecent: false)

        let results = try await sut.searchExperiences(by: "Pyramids")
        XCTAssertEqual(results.count, 2)
        XCTAssertTrue(results.contains(where: { $0.id == "1" }))
        XCTAssertTrue(results.contains(where: { $0.id == "2" }))
    }

    func test_searchExperiences_caseInsensitiveMatch() async throws {
        let item = makeExperience(id: "1", title: "Nile Cruise", order: 0)
        try await sut.saveOrUpdateExperience(item)

        let results = try await sut.searchExperiences(by: "nile")
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.id, "1")
    }

    // MARK: - Tests for likeExperience(id:)

    func test_likeExperience_successChangesIsLiked() async throws {
        let item = makeExperience(id: "1", isLiked: false)
        try await sut.saveOrUpdateExperience(item)

        let result = try await sut.likeExperience(id: "1", likesNo: 4)
        XCTAssertNotNil(result)
        XCTAssertTrue(result!.isLiked)

        // Verify it persists
        let fetched = try await sut.getExperienceDetails(by: "1")
        XCTAssertTrue(fetched.isLiked)
    }

    func test_likeExperience_alreadyLiked_keepsLikedTrue() async throws {
        let item = makeExperience(id: "1", isLiked: true)
        try await sut.saveOrUpdateExperience(item)

        let result = try await sut.likeExperience(id: "1", likesNo: 4)
        XCTAssertNotNil(result)
        XCTAssertTrue(result!.isLiked)
    }

    func test_likeExperience_invalidId_throwsUpdateFailedWithNotFound() async throws {
        do {
            _ = try await sut.likeExperience(id: "invalid", likesNo: 4)
            XCTFail("Expected likeExperience to throw an error")
        } catch let error as DatabaseError {
            switch error {
            case .updateFailed(let underlying):
                if let dbError = underlying as? DatabaseError {
                    switch dbError {
                    case .notFound:
                        break // ✅ Expected
                    default:
                        XCTFail("Unexpected underlying DatabaseError: \(dbError)")
                    }
                } else {
                    XCTFail("Underlying error is not DatabaseError: \(underlying)")
                }
            default:
                XCTFail("Unexpected DatabaseError case: \(error)")
            }
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
}
