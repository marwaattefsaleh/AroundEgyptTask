//
//  ExperienceRemoteDataSourceTests.swift
//  AroundEgyptTask
//
//  Created by Marwa Attef on 28/10/2025.
//

import XCTest
import Foundation
@testable import AroundEgyptTask
import Alamofire

// MARK: - Test Class
class ExperienceRemoteDataSourceTests: XCTestCase {
    var sut: ExperienceRemoteDataSource!
    var mockService: MockNetworkService!

    override func setUp() {
        super.setUp()
        mockService = MockNetworkService()
        sut = ExperienceRemoteDataSource(networkService: mockService)
    }

    override func tearDown() {
        sut = nil
        mockService = nil
        super.tearDown()
    }

    // MARK: - Helpers
    func makeDTO(id: String = "1") -> ExperienceDTO {
        return ExperienceDTO(
            id: id,
            title: "Test Experience",
            coverPhoto: nil,
            desc: "Description",
            viewsNo: 10,
            likesNo: 5,
            recommended: 1,
            hasVideo: 0,
            tags: nil,
            city: nil,
            tourHTML: nil,
            famousFigure: nil,
            period: nil,
            era: nil,
            founded: nil,
            detailedDescription: nil,
            address: nil,
            gmapLocation: nil,
            openingHours: nil,
            translatedOpeningHours: nil,
            startingPrice: nil,
            ticketPrices: nil,
            experienceTips: nil,
            isLiked: false,
            reviews: nil,
            rating: nil,
            reviewsNo: nil,
            audioURL: nil,
            hasAudio: false
        )
    }

    func makeBaseResponse<T: Codable>(data: T?) -> BaseResponse<T> {
        let meta = Meta(code: 200, errors: nil, exception: nil)
        return BaseResponse(meta: meta, data: data, pagination: nil)
    }

    // MARK: - getExperiences(filter:)
    func test_getExperiences_withFilter_success() async throws {
        let dto = makeDTO()
        mockService.result = .success(makeBaseResponse(data: [dto]))

        let results = try await sut.getExperiences(filter: ["filter[recommended]": true])
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results[0].id, dto.id)
    }

    func test_getExperiences_withFilter_emptyArray_returnsEmpty() async throws {
        mockService.result = .success(makeBaseResponse(data: [ExperienceDTO]()))

        let results = try await sut.getExperiences(filter: ["filter[recommended]": true])
        XCTAssertEqual(results.count, 0)
    }

    func test_getExperiences_failure_throws() async {
        mockService.result = .failure(NetworkError.notFound)

        do {
            _ = try await sut.getExperiences(filter: ["filter[recommended]": true])
            XCTFail("Expected to throw NetworkError.notFound")
        } catch let error as NetworkError {
            switch error {
            case .notFound: break
            default:
                XCTFail("Unexpected error: \(error)")
            }
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }

    // MARK: - getExperienceDetails(by:)
    func test_getExperienceDetails_success() async throws {
        let dto = makeDTO()
        mockService.result = .success(makeBaseResponse(data: dto))

        let result = try await sut.getExperienceDetails(by: "1")
        XCTAssertEqual(result?.id, dto.id)
    }

    func test_getExperienceDetails_failure_throws() async {
        mockService.result = .failure(NetworkError.notFound)

        do {
            _ = try await sut.getExperienceDetails(by: "invalid_id")
            XCTFail("Expected to throw NetworkError.notFound")
        } catch let error as NetworkError {
            switch error {
            case .notFound: break
            default:
                XCTFail("Unexpected error: \(error)")
            }
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }

    // MARK: - likeExperience(id:)
    func test_likeExperience_success() async throws {
        let dto = makeDTO()
        mockService.result = .success(makeBaseResponse(data: 5))

        let likesNo = try await sut.likeExperience(id: "1")
        XCTAssertEqual(likesNo, dto.likesNo)
    }

    func test_likeExperience_failure_throws() async {
        mockService.result = .failure(NetworkError.notFound)

        do {
            _ = try await sut.likeExperience(id: "1")
            XCTFail("Expected to throw NetworkError.notFound")
        } catch let error as NetworkError {
            switch error {
            case .notFound: break
            default:
                XCTFail("Unexpected error: \(error)")
            }
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
}
