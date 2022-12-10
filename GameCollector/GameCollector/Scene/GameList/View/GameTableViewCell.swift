//
//  GameTableViewCell.swift
//  GameCollector
//
//  Created by Ali Rıza İLHAN on 10.12.2022.
//

import UIKit

final class GameTableViewCell: UITableViewCell {
    @IBOutlet private weak var gameImage: UIImageView!
    @IBOutlet private weak var gameName: UILabel!

    func configureCell( name: String  ){
        gameName.text = name
    }
}
