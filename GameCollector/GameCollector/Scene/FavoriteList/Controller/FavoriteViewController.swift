//
//  FavoriteViewController.swift
//  GameCollector
//
//  Created by Ali Rıza İLHAN on 15.12.2022.
//

import UIKit

final class FavoriteViewController: BaseViewController {
    @IBOutlet private weak var favoritesTableView: UITableView! {
        didSet {
            favoritesTableView.delegate = self
            favoritesTableView.dataSource = self
        }
    }
    private var viewModel: FavoritesViewModelProtocol = FavoritesViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        favoritesTableView.reloadData()
        self.title = "Favorite Games"
        NotificationCenter.default.addObserver(self, selector: #selector(favoriteIsUpdated), name: NSNotification.Name("favoritesIsUpdatedNotification") , object: nil)
    }
    @objc func favoriteIsUpdated() {
        favoritesTableView.reloadData()
        print("viewModel.getFavoritesCount()\(viewModel.getFavoritesCount())")
    }
}

extension FavoriteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getFavoritesCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath) as? GameTableViewCell,
            let model = viewModel.getFavorite(at: indexPath.row) else { return UITableViewCell() }
        cell.configureCellForFavorite(model: model)
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GameDetailViewController") as? GameDetailViewController else { return }
        guard let id = viewModel.getFavorite(at: indexPath.row)?.id else { return }
        let gameId = Int(id)
        detailVC.gameId = gameId
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let game = viewModel.getFavorite(at: indexPath.row)
            guard let id = game?.id else { return }
            let gameId = Int(id)
            viewModel.editFavorite(game: game!)
            favoritesTableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}
