//
//  NoteListViewModel.swift
//  GameCollector
//
//  Created by Ali Rıza İLHAN on 16.12.2022.
//

import Foundation

protocol NoteListViewProtocol {
    func getNotesCount() -> Int
    func getNote(at index: Int) -> Note?
    func editNote(userNote: UserNoteModel)
    func removeNote(userNote: Note)
}

final class NoteListViewModel: NoteListViewProtocol {
    func getNotesCount() -> Int {
        CoreDataManager.shared.getNotes().count
    }
    
    func getNote(at index: Int) -> Note? {
        CoreDataManager.shared.getNotes()[index]
    }
    
    func editNote(userNote: UserNoteModel) {
        CoreDataManager.shared.updateNote(noteModel: userNote)
    }
    func removeNote(userNote: Note) {
        CoreDataManager.shared.removeNote(noteId: userNote.id!)
    }
    
}
