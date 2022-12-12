//
//  PlatformElementModel.swift
//  GameCollector
//
//  Created by Ali Rıza İLHAN on 11.12.2022.
//

import Foundation

// MARK: - PlatformElementModel
struct PlatformElementModel: Codable {
    let platform: PlatformPlatform
   
}
// MARK: - PlatformPlatform
struct PlatformPlatform: Codable {
    let id: Int?
    let name, slug: String?
    let image, yearEnd: String?
    let yearStart: Int?
    let gamesCount: Int?
    let imageBackground: String?

    enum CodingKeys: String, CodingKey {
        case id, name, slug, image
        case yearEnd = "year_end"
        case yearStart = "year_start"
        case gamesCount = "games_count"
        case imageBackground = "image_background"
    }
}

