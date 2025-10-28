//
//  ExperienceDTO.swift
//  AroundEgyptTask
//
//  Created by Marwa Attef on 28/10/2025.
//
import Foundation

struct ExperienceDTO: Codable, Identifiable {
    let id: String
    let title: String
    let coverPhoto: String?
    let desc: String?
    let viewsNo: Int?
    let likesNo: Int?
    let recommended: Int?
    let hasVideo: Int?
    let tags: [TagDTO]?
    let city: CityDTO?
    let tourHTML: String?
    let famousFigure: String?
    let period: PeriodDTO?
    let era: EraDTO?
    let founded: String?
    let detailedDescription: String?
    let address: String?
    let gmapLocation: GMapLocationDTO?
    let openingHours: OpeningHoursDTO?
    let translatedOpeningHours: TranslatedOpeningHoursDTO?
    let startingPrice: Double?
    let ticketPrices: [TicketPriceDTO]?
    let experienceTips: [String]?
    let isLiked: Bool?
    let reviews: [ReviewDTO]?
    let rating: Double?
    let reviewsNo: Int?
    let audioURL: String?
    let hasAudio: Bool?

    enum CodingKeys: String, CodingKey {
        case id, title, recommended, tags, city, period, era, founded, address, rating
        case desc = "description"
        case coverPhoto = "cover_photo"
        case viewsNo = "views_no"
        case likesNo = "likes_no"
        case hasVideo = "has_video"
        case tourHTML = "tour_html"
        case famousFigure = "famous_figure"
        case detailedDescription = "detailed_description"
        case gmapLocation = "gmap_location"
        case openingHours = "opening_hours"
        case translatedOpeningHours = "translated_opening_hours"
        case startingPrice = "starting_price"
        case ticketPrices = "ticket_prices"
        case experienceTips = "experience_tips"
        case isLiked = "is_liked"
        case reviews, reviewsNo = "reviews_no"
        case audioURL = "audio_url"
        case hasAudio = "has_audio"
    }
}
extension ExperienceDTO {
    func toEntity(isRecent: Bool = false) -> ExperienceEntity {
        return ExperienceEntity(id: id, title: title, desc: desc, coverPhoto: coverPhoto, likesNo: likesNo ?? 0, viewsNo: viewsNo ?? 0, isRecommended: recommended == 1, isRecent: isRecent, isLiked: isLiked ?? false, cityName: city?.name)
    }
    
    func toDBModel(isRecent: Bool) -> ExperienceDBModel {
        return ExperienceDBModel(id: id, title: title, desc: desc ?? "", coverPhoto: coverPhoto, likesNo: likesNo ?? 0, viewsNo: viewsNo ?? 0, isRecommended: recommended == 1, isRecent: isRecent, isLiked: isLiked ?? false, cityName: city?.name)
    }
}
