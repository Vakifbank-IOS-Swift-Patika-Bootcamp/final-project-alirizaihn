//
//  ViewController.swift
//  GameCollector
//
//  Created by Ali Rıza İLHAN on 7.12.2022.
//

import UIKit

struct Game {
    var name: String
}

final class GameListViewController: UIViewController {

    @IBOutlet private weak var gameListTableView: UITableView! {
        didSet {
            gameListTableView.delegate = self
            gameListTableView.dataSource = self
        }
    }
    let searchController = UISearchController()
    let games: [Game] = [Game(name: "ali"),Game(name: "veli"),Game(name: "faruk")]
    var filteredGames = [Game]()
    var scopeButtonPressed = false
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("aşsdlkasşd")
        initSearchController()
        gameListTableView.tableFooterView = UIView()
        
    }
    func initSearchController() {
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        searchController.searchBar.showsScopeBar = true
        searchController.searchBar.scopeButtonTitles = ["All", "Rect","Sqaure", "Octagon", "Circle", "Triangle"]
        definesPresentationContext = true
        self.navigationItem.searchController = searchController
        self.navigationItem.title = "Game List"
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.up.and.down.text.horizontal"), style: UIBarButtonItem.Style.done, target: self, action: #selector(showSearch))
       

    }
    @objc func showSearch () {
        
    }
}

extension GameListViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        games.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("merak: \(games[indexPath.row].name)")
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath) as? GameTableViewCell else {
            return UITableViewCell()
        }
        cell.configureCell(name: games[indexPath.row].name)
      
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("item selected")
    }
    
     
}
extension GameListViewController : UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scopeButton = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        let searchText = searchBar.text!
        
        filterForSearchTextAndScopeButton(searchText: searchText, scopeButton: scopeButton)
    }
    func filterForSearchTextAndScopeButton(searchText: String, scopeButton: String = "All") {
        filteredGames = games.filter {
            game in
            let scopeMatch = (scopeButton == "All" )
            if(searchController.searchBar.text != "") {
                let searchTextMatch =  game.name.contains(searchText.lowercased())
                return scopeMatch && searchTextMatch
            }
            else {
                return scopeMatch
            }
        }
        gameListTableView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        searchController.searchBar.text = ""
        scopeButtonPressed = true
        let scopeButton = searchController.searchBar.scopeButtonTitles!
        [searchController.searchBar.selectedScopeButtonIndex]
        gameListTableView.reloadData()
        
    }
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        print("Click")
    }
   
    
}
