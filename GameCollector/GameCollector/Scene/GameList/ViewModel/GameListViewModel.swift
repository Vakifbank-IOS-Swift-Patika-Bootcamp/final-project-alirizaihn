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

final class GameListViewModel: GameListViewModelProtocol {
    weak var delegate: GameListViewModelDelegate?
    
    private var searchText: String?
    private var page: Int = 1
    private var games: [GameModel] = []
    private var genres: [GenreModel] = []
    private var selectedGenreId: Int?
    private var selectedSortingFilter: String?
    
    func getGamesCount() -> Int {
        return games.count
    }
    
    func getGame(at index: Int) -> GameModel? {
        games[index]
    }
    
    func fetchGames() {
        delegate?.startFetching()
        
        GameServisClient.getGameList(searchText: searchText, genreId: selectedGenreId, page: page, ordering: selectedSortingFilter) { [weak self] games, error in
            guard let self = self else { return }
            self.delegate?.endingFetching()
            
            if let error = error {
                self.delegate?.onError(message: error.localizedDescription)
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
    
    func fetchGenres() {
        GameServisClient.fetchGenres(page: 1, pageSize: 4) { [weak self] genres, error in
            guard let self = self else { return }
            self.genres = genres ?? []
            self.delegate?.genreLoaded()
        }
    }
    
    func getGenresName() -> [String]? {
        var genreNameArray = genres.map { $0.name ?? "" }
        genreNameArray.insert("All", at: 0)
        return genreNameArray
    }
    
    func fetchGameByGenre(genreId: Int?) {
        selectedGenreId = genreId
        clearFilter()
        fetchGames()
    }
    
    func getGenre(at index: Int) -> GenreModel? {
        genres[index]
    }
    
    func fetchGamesBySortingFilter(sortingFilter: String) {
        selectedSortingFilter = sortingFilter
        clearFilter()
        fetchGames()
    }
    
    private func clearFilter() {
        games = []
        page = 1
    }
    
    func fetchMore() {
        page += 1
        fetchGames()
    }
    
    func searchGames(searchText: String?) {
        self.searchText = searchText
        clearFilter()
        fetchGames()
    }
}
