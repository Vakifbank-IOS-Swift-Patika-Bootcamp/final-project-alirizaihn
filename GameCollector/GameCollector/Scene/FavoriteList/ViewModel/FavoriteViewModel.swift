//
//  FavoriteViewModel.swift
//  GameCollector
//
//  Created by Ali Rıza İLHAN on 15.12.2022.
//

import Foundation

protocol FavoritesViewModelProtocol {
    func getFavoritesCount() -> Int
    func getFavorite(at index: Int) -> Game?
    func editFavorite(game: Game)
}

final class FavoritesViewModel: FavoritesViewModelProtocol {
   
    func getFavoritesCount() -> Int {
        CoreDataManager.shared.getGamesFromFavorites().count
    }
    
    func getFavorite(at index: Int) -> Game? {
        CoreDataManager.shared.getGamesFromFavorites()[index]
    }
    
    func editFavorite(game: Game) {
        CoreDataManager.shared.removeGameFromFavorites(gameId: Int(game.id))
    }
}
