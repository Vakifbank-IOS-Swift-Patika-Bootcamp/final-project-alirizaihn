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
    func fetchGenres()
    func searchGames(searchText: String?)
    func fetchMore()
    func getGenresName() -> [String]?
    func fetchGameByGenre(genreId: Int?)
    func getGenre(at index: Int) -> GenreModel?
    func fetchGamesBySortingFilter(sortingFilter: String)
}

protocol GameListViewModelDelegate: AnyObject {
    func startFetching()
    func endingFetching()
    func gameLoaded()
    func genreLoaded()
    func onError(message: String)
}

final class GameListViewModel : GameListViewModelProtocol {
    func fetchGamesBySortingFilter(sortingFilter: String) {
        self.selectedSortingFilter = sortingFilter
        clearFilter()
        fetchGames()
    }
    
    func getGenre(at index: Int) -> GenreModel? {
        self.genres[index]
    }
    
    func fetchGameByGenre(genreId: Int?) {
        self.selectedGenreId = genreId
        clearFilter()
        fetchGames()
    }
    
    func fetchGenres() {
        GameServisClient.fetchGenres(page: 1, pageSize: 4) { [weak self] gengers, error in
            guard let self = self else { return }
            self.genres = gengers ?? []
            self.delegate?.genreLoaded()
        }
    }
    
    func getGenresName() -> [String]? {
      var genreNameArray = genres.map {$0.name ?? ""}
        genreNameArray.insert("All", at: 0)
        return genreNameArray
    }
    
    
    private var searchText: String?
    private var page: Int = 1
    weak var delegate: GameListViewModelDelegate?
    private var games: [GameModel] = []
    private var genres: [GenreModel] = []
    private var selectedGenreId: Int?
    private var selectedSortingFilter: String?
    
    func getGamesCount() -> Int {
        return games.count ?? 0
    }
    
    func getGame(at index: Int) -> GameModel? {
        games[index]
    }
    
    func fetchGames() {
        self.delegate?.startFetching()
        GameServisClient.getGameList(searchText: self.searchText, genreId: self.selectedGenreId, page: self.page, ordering: self.selectedSortingFilter) { [weak self] games, error in
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
        
        
    }
    private func clearFilter() {
        self.games = []
        self.page = 1
    }
    
    func fetchMore() {
        self.page += 1
        fetchGames()
    }
    
    func searchGames(searchText : String?) {
        self.searchText = searchText
        clearFilter()
        fetchGames()
        
    }
    
}
