//
//  GameDetailViewModel.swift
//  GameCollector
//
//  Created by Ali Rıza İLHAN on 15.12.2022.
//

import Foundation

protocol GameDetailViewModelProtocol {
    var delegate: GameDetailViewModelDelegate? {get set}
    func fetchGame(id: Int)
    func editFavorite()
    func setGameId(id: Int)
    func getGame() -> GameModel?
    func getButtonImage() -> String
}

protocol GameDetailViewModelDelegate: AnyObject {
    func startFetching()
    func endingFetching()
    func gameLoaded()
    func onError(message: String)
}

final class GameDetailViewModel: GameDetailViewModelProtocol {
    
    private var gameId: Int?
    private var game:GameModel?
    
    weak var delegate: GameDetailViewModelDelegate?
    
    func getButtonImage() -> String {
        isGameInFavorites() ? "heart.fill" : "heart"
    }
    func getGame() -> GameModel? {
        game
    }
    
    func setGameId(id: Int) {
        self.gameId = id
    }
    
    func fetchGame(id: Int) {
        delegate?.startFetching()
        GameServisClient.fetchGame(id: id) { [weak self] game, error in
            guard let self = self else { return }
            self.delegate?.endingFetching()
            
            if let error = error {
                self.delegate?.onError(message: error.localizedDescription)
                return
            }
            
            self.game = game
            self.delegate?.gameLoaded()
            
        }
    }
    
    func editFavorite() {
        if let game = self.game {
            if isGameInFavorites() {
                CoreDataManager.shared.removeGameFromFavorites(gameId: game.id!)
                NotificationCenter.default.post(name: NSNotification.Name("favoritesIsUpdatedNotification"), object: nil)
            } else {
                CoreDataManager.shared.addGameToFavorites(newGame: game)
                NotificationCenter.default.post(name: NSNotification.Name("favoritesIsUpdatedNotification"), object: nil)
            }
            
        }
    }
    
    func isGameInFavorites () -> Bool {
        let favoriteGames = CoreDataManager.shared.getGamesFromFavorites()
        if let game = self.game {
            if favoriteGames.contains(where: {$0.id == game.id!}) {
                return true
            } else {
                return  false
            }
        } else {
            return false
        }
    }
    
}


