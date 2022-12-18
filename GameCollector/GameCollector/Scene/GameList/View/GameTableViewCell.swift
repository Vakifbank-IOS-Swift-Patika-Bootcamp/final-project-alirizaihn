//
//  GameTableViewCell.swift
//  GameCollector
//
//  Created by Ali Rıza İLHAN on 10.12.2022.
//

import UIKit
import AlamofireImage
final class GameTableViewCell: UITableViewCell {
    @IBOutlet private weak var gameImage: UIImageView!
    @IBOutlet private weak var gameName: UILabel!
    @IBOutlet private weak var releaseDate: UILabel!
    @IBOutlet private weak var ratingLabel: UILabel!
    
    override func prepareForReuse() {
        gameImage.image = nil
    }
    func configureCell(model: GameModel  ){
        gameName.text = model.name ?? ""
        guard let imageUrlString = model.backgroundImage, let url = URL(string: imageUrlString), let releaseDate = model.released, let rating = model.rating, let totalRating = model.ratingsCount else { return }
        gameImage.af.setImage(withURL: url, placeholderImage: UIImage(named: "placeholderImg.jpeg"))
        self.releaseDate.text = releaseDate
        self.ratingLabel.text = "\(String(rating)) | \(String(totalRating))  Rating"
    }
    func configureCellForFavorite(model: Game) {
        gameName.text = model.name
        releaseDate.text = model.released
        ratingLabel.text = "\(String(model.rating)) | \(String(model.ratingsCount))  Rating"
        guard let imageUrlString = model.backgroundImage, let url = URL(string: imageUrlString) else { return }
        gameImage.af.setImage(withURL: url, placeholderImage: UIImage(named: "placeholderImg.jpeg"))
       
    }
}
