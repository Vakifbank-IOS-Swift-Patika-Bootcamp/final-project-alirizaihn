//
//  GetGamesResponseModel.swift
//  GameCollector
//
//  Created by Ali Rıza İLHAN on 11.12.2022.
//

import Foundation

struct GetGengersResponseModel: Codable {
    let count: Int?
    let next, previous: String?
    let results: [GenreModel]?
}
