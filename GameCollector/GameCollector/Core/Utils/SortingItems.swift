//
//  SortingItems.swift
//  GameCollector
//
//  Created by Ali Rıza İLHAN on 14.12.2022.
//

import Foundation

enum SortingItems: String, CaseIterable {
    case name = "A-Z"
    case reverseName = "Z-A"
    case rating = "Rating"
    case updated = "Newest"
    
    func filterValue() -> String {
        switch self {
        case .name:
            return "name"
        case .reverseName:
            return "-name"
        case .rating:
            return "rating"
        case.updated:
            return "updated"
        }
    }
}
