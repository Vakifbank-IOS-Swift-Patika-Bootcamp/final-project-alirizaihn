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
    
    override func prepareForReuse() {
        gameImage.image = nil
    }
    func configureCell(model: GameModel  ){
        gameName.text = model.name ?? "a"
        guard let imageUrlString = model.backgroundImage, let url = URL(string: imageUrlString) else { return }
        gameImage.af.setImage(withURL: url, placeholderImage: UIImage(named: "placeholderImg.jpeg"))
    }
    func configureCellForFavorite(model: Game) {
        gameName.text = model.name
        guard let imageUrlString = model.backgroundImage, let url = URL(string: imageUrlString) else { return }
        gameImage.af.setImage(withURL: url, placeholderImage: UIImage(named: "placeholderImg.jpeg"))
    }
}
