//
//  GameListViewModel.swift
//  GameCollector
//
//  Created by Ali Rıza İLHAN on 11.12.2022.
//

import Foundation

protocol GameListViewModelProtocol {
    var  delegate: GameListViewModelDelegate? {get set}
    func getGamesCount() -> Int
    func getGame(at index: Int) -> GameModel?
    func fetchGames()
    func searchGames(searchText: String?)
    func fetchMore()
}

protocol GameListViewModelDelegate: AnyObject {
    func startFetching()
    func endingFetching()
    func gameLoaded()
    func onError(message: String)
}

final class GameListViewModel : GameListViewModelProtocol {
 
  

    private var searchText: String?
    private var page: Int = 1
    weak var delegate: GameListViewModelDelegate?
    private var games: [GameModel] = []
    private var gengers: [GenreModel] = []
    
    func getGamesCount() -> Int {
        return games.count ?? 0
    }
    
    func getGame(at index: Int) -> GameModel? {
        games[index]
    }
    
    
    func fetchGames() {
        self.delegate?.startFetching()
        GameServisClient.getGameList(searchText: self.searchText, filterText: "", page: self.page) { [weak self] games, error in
            guard let self = self else { return }
            self.delegate?.endingFetching()
            if let error = error {
                self.delegate?.onError(message:  error.localizedDescription)
               return
            }
            if games?.isEmpty ?? true {
                if self.page > 1 {
                    self.page -= 1
                }
                self.delegate?.onError(message: "No Game")
                return
            }

            self.games += games ?? []
            self.delegate?.gameLoaded()
           
        }
        GameServisClient.fetchGenres(page: 1, pageSize: 5) { [weak self] gengers, error in
            guard let self = self else { return }
            print("gaada\(gengers)")
        }
    }
    
    func fetchMore() {
        self.page += 1
        fetchGames()
    }
    
    func searchGames(searchText : String?) {
        self.searchText = searchText
        self.games = []
        self.page = 1
        fetchGames()
       
    }
    
    
    
}
