//
//  ViewController.swift
//  GameCollector
//
//  Created by Ali Rıza İLHAN on 7.12.2022.
//

import UIKit



final class GameListViewController: BaseViewController {
    
    @IBOutlet private weak var gameListTableView: UITableView! {
        didSet {
            gameListTableView.delegate = self
            gameListTableView.dataSource = self
        }
    }
    private var viewModel: GameListViewModelProtocol = GameListViewModel()
    private let searchController = UISearchController(searchResultsController: nil)
    private var timer = Timer()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        initSearchController()
        gameListTableView.tableFooterView = UIView()
        viewModel.delegate = self
        viewModel.fetchGames()
        viewModel.fetchGenres()
        
    }
    func initSearchController() {
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        searchController.searchBar.showsScopeBar = true
        searchController.searchBar.scopeButtonTitles = viewModel.getGenresName()
        definesPresentationContext = true
        self.navigationItem.searchController = searchController
        self.navigationItem.title = "Game List"
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.up.and.down.text.horizontal"), style: UIBarButtonItem.Style.done, target: self, action: #selector(showSearch))
    }
    @objc func showSearch () {
        SortingView.showView() { selectedSortingFilter in
            if let selectedSortingFilter = selectedSortingFilter {
                self.viewModel.fetchGamesBySortingFilter(sortingFilter: selectedSortingFilter.filterValue())
            }
        }
        
    }
}

extension GameListViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.getGamesCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath) as? GameTableViewCell,
              let model = viewModel.getGame(at: indexPath.row) else { return UITableViewCell() }
        cell.configureCell(model: model)
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.item == viewModel.getGamesCount() - 1 {
            viewModel.fetchMore()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("item selected")
    }
    
    
}
extension GameListViewController : UISearchResultsUpdating, UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if !(searchBar.text?.isEmpty ?? true){
            viewModel.searchGames(searchText: "")
        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.searchGames(searchText: String(searchText))
                
            })
    }
    func updateSearchResults(for searchController: UISearchController) {
                let searchBar = searchController.searchBar
                let scopeButton = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
                let searchText = searchBar.text!
     
     
        //        filterForSearchTextAndScopeButton(searchText: searchText, scopeButton: scopeButton)
    }
  
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        print("clasda\(selectedScope)")
        if selectedScope != 0 {
            let selectedGenreId = self.viewModel.getGenre(at: selectedScope-1 )?.id
            self.viewModel.fetchGameByGenre(genreId: selectedGenreId)
        } else {
            self.viewModel.fetchGameByGenre(genreId: nil)
        }
       
        //        scopeButtonPressed = true
        //        let scopeButton = searchController.searchBar.scopeButtonTitles!
        //        [searchController.searchBar.selectedScopeButtonIndex]
        //        gameListTableView.reloadData()
        
    }
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        print("Click")
    }
    
    
}
extension GameListViewController: GameListViewModelDelegate {
    func genreLoaded() {
        print("Genre=> \(viewModel.getGenresName())")
        self.initSearchController()
    }
    
    func startFetching() {
        self.indicator.startAnimating()
    }
    
    func endingFetching() {
        self.indicator.stopAnimating()
    }
    
    func gameLoaded() {
       gameListTableView.reloadData()
    }
    
    func onError(message: String) {
        self.showErrorAlert(message: message) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
}
