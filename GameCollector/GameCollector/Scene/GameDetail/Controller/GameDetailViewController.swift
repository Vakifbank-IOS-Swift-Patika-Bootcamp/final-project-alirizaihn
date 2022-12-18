//
//  GameDetailViewController.swift
//  GameCollector
//
//  Created by Ali Rıza İLHAN on 15.12.2022.
//

import UIKit
import AlamofireImage
final class GameDetailViewController: BaseViewController {

    @IBOutlet private weak var gameImageView: UIImageView!
    @IBOutlet private weak var idLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet private weak var raingLabel: UILabel!
    @IBOutlet private weak var releaseDateLabel: UILabel!
    @IBOutlet private weak var gameDescriptionLabel: UILabel!
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
            self.nameLabel.text = String(gameName)
        }
        guard let imageUrlString = gameInstance?.backgroundImage, let url = URL(string: imageUrlString) else { return }
        gameImageView.af.setImage(withURL: url, placeholderImage: UIImage(named: "placeholderImg.jpeg"))
        guard let rating = gameInstance?.rating, let ratingCount = gameInstance?.ratingsCount else { return }
        self.raingLabel.text = String(rating) + " (  \(String(ratingCount)) rating)"
        guard let releaseDate = gameInstance?.released else { return }
        self.releaseDateLabel.text = releaseDate
        guard let description = gameInstance?.description else { return }
        self.gameDescriptionLabel.text = description.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        
    }
    
    func onError(message: String) {
        self.showErrorAlert(message: message) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
}

