//
//  GameListViewModel.swift
//  GameCollector
//
//  Created by Ali Rıza İLHAN on 11.12.2022.
//

import Foundation

// Protocol that defines the properties and methods that the GameListViewModel class should implement
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

// Protocol that defines the methods that the delegate of a GameListViewModel instance should implement
protocol GameListViewModelDelegate: AnyObject {
    func startFetching()
    func endingFetching()
    func gameLoaded()
    func genreLoaded()
    func onError(message: String)
}

// View model class that manages a collection of games and genres, and provides methods to search, sort, and filter these games
final class GameListViewModel: GameListViewModelProtocol {
    weak var delegate: GameListViewModelDelegate?
    
    private var searchText: String?
    private var page: Int = 1 // Declare a variable to store the current page of games being displayed.
    private var games: [GameModel]?
    private var genres: [GenreModel] = []
    private var selectedGenreId: Int?
    private var selectedSortingFilter: String?
    
    func getGamesCount() -> Int {
        return games?.count ?? 0
    }
    
    func getGame(at index: Int) -> GameModel? {
        games?[index]
    }
    
    // Fetch a list of games from the server.
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
            
            if self.games?.count ?? 0 > 0 {
                self.games! += games ?? []
            } else {
                self.games = games
            }
            self.delegate?.gameLoaded()
        }
    }
    
    // Fetch a list of genres from the server.
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
        print("bakacapız5")
        fetchGames()
    }
    
    func getGenre(at index: Int) -> GenreModel? {
        genres[index]
    }
    
    func fetchGamesBySortingFilter(sortingFilter: String) {
        selectedSortingFilter = sortingFilter
        clearFilter()
        fetchGames()
        print("bakacapız4")
    }
    
    private func clearFilter() {
        games = []
        page = 1
    }
    
    func fetchMore() {
        page += 1
        fetchGames()
        print("bakacapız3")
    }
    
    func searchGames(searchText: String?) {
        self.searchText = searchText
        clearFilter()
        fetchGames()
        print("bakacapız2")
    }
}
