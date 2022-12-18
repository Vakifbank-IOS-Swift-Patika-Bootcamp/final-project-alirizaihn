//
//  CreateNoteViewModel.swift
//  GameCollector
//
//  Created by Ali Rıza İLHAN on 16.12.2022.
//

import Foundation

protocol CreateNoteViewProtocol {
    var delegate: CreateNoteViewDelegate? {get set}
    func saveNote (note: Note?, userNoteModel: UserNoteModel)
    
}
protocol CreateNoteViewDelegate: AnyObject {
    func noteSaved()
    func onError(message: String)
}

final class CreateNoteViewModel: CreateNoteViewProtocol {

    weak var delegate: CreateNoteViewDelegate?
    private var userNote: UserNoteModel?
    
    func saveNote(note: Note?, userNoteModel: UserNoteModel) {
        if (userNoteModel.gameName == "" || userNoteModel.userNote == "") {
            self.delegate?.onError(message: "Please fill in all the blanks. ")
        } else {
            self.userNote = userNoteModel
            if note != nil {
                self.userNote?.id = (note?.id)!
                CoreDataManager.shared.updateNote(noteModel: self.userNote!)
            } else {
                CoreDataManager.shared.saveNote(newNote: self.userNote!)
            }
            self.delegate?.noteSaved()
        }
    }
    
    
}

