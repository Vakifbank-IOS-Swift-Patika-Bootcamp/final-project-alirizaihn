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

    func configureCell( model: GameModel  ){
        gameName.text = model.name
        guard let url = URL(string: model.backgroundImage) else { return }
        gameImage.af.setImage(withURL: url)
    }
}
