//
//  GameListViewModel.swift
//  GameCollector
//
//  Created by Ali Rıza İLHAN on 11.12.2022.
//

import Foundation

protocol GameListViewModelProtocol {
    var delegate: GameListViewModelDelegate? {get set}
    func getGamesCount() -> Int
    func getGame(at index: Int) -> GameModel?
    func fetchGames()

}

protocol GameListViewModelDelegate: AnyObject {
    func startFetching()
    func endingFetching()
    func gameLoaded()
    func onError(message: String)
}
final class GameListViewModel : GameListViewModelProtocol {
    weak var delegate: GameListViewModelDelegate?
    private var games: [GameModel]?
    
    func getGamesCount() -> Int {
        return games?.count ?? 0
    }
    
    func getGame(at index: Int) -> GameModel? {
        games?[index]
    }
    
    func fetchGames() {
        self.delegate?.startFetching()
        GameServisClient.getGameList { [weak self] games, error in
            guard let self = self else { return }
            self.delegate?.endingFetching()
            if let error = error {
                self.delegate?.onError(message:  error.localizedDescription)
               return
            }
            if games?.isEmpty ?? true {
                self.delegate?.onError(message: "No Game")
                return
            }
            print("baksdawa\(games)")
            self.games = games
            self.delegate?.gameLoaded()
           
        }
    }
    
    
}
