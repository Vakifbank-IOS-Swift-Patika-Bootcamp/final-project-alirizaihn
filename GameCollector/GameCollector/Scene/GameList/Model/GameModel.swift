//
//  GameModel.swift
//  GameCollector
//
//  Created by Ali Rıza İLHAN on 11.12.2022.
//

import Foundation

struct GameModel: Codable {
    let id: Int?
    let slug, name, released: String?
    let backgroundImage: String?
    let rating: Double?
    let ratingTop, ratingsCount, metacritic, playtime: Int?
    let suggestionsCount: Int?
    let updated: String?
    let reviewsCount: Int?
    let saturatedColor, dominantColor: String?
    let platforms: [PlatformElementModel]?
    let genres: [GenreModel]?

    enum CodingKeys: String, CodingKey {
        case id, slug, name, released
        case backgroundImage = "background_image"
        case rating
        case ratingTop = "rating_top"
        case ratingsCount = "ratings_count"
        case metacritic, playtime
        case suggestionsCount = "suggestions_count"
        case updated
        case reviewsCount = "reviews_count"
        case saturatedColor = "saturated_color"
        case dominantColor = "dominant_color"
        case platforms, genres
    }
}
