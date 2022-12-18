//
//  UserNoteTableViewCell.swift
//  GameCollector
//
//  Created by Ali Rıza İLHAN on 16.12.2022.
//

import UIKit

final class UserNoteTableViewCell: UITableViewCell {
    @IBOutlet private var datelabel: UILabel!
    @IBOutlet private var gameNameLabel: UILabel!
    @IBOutlet private var noteLabel: UILabel!
   
    func configureCell(userNoteModel: Note) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-YYYY"
        let dateString = dateFormatter.string(from: userNoteModel.date!)

        datelabel.text = "Date: " + dateString
        gameNameLabel.text = "Game: " + (userNoteModel.gameName ?? "")
        noteLabel.text = userNoteModel.userNote
        
    }
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
}
