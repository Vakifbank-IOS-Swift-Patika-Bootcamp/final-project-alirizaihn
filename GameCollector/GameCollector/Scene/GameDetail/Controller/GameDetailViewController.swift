//
//  GameDetailViewController.swift
//  GameCollector
//
//  Created by Ali Rıza İLHAN on 15.12.2022.
//

import UIKit

final class GameDetailViewController: BaseViewController {

    @IBOutlet private weak var idLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var likeButton: UIButton!
    var gameId : Int?
    var viewModel: GameDetailViewModelProtocol = GameDetailViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        if let gameId = gameId {
            viewModel.fetchGame(id: gameId)
        }
    }
    
    @IBAction func editFavoriteButtonPressed(_ sender: Any) {
        viewModel.editFavorite()
        if let likeImage = UIImage(systemName: self.viewModel.getButtonImage()) {
            self.likeButton.setImage(likeImage, for: .normal)
        }
    }
    
}

extension GameDetailViewController: GameDetailViewModelDelegate {
    func startFetching() {
        self.indicator.startAnimating()
    }

    func endingFetching() {
        self.indicator.stopAnimating()
    }

    func gameLoaded() {
        if let likeImage = UIImage(systemName: self.viewModel.getButtonImage()) {
            self.likeButton.setImage(likeImage, for: .normal)
        }
        let gameInstance = viewModel.getGame()
        if let gameID = gameInstance?.id, let gameName = gameInstance?.name {
            self.idLabel.text = String(gameID)
            self.nameLabel.text = String(gameName)
        }
    }
    
    func onError(message: String) {
        self.showErrorAlert(message: message) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
}
