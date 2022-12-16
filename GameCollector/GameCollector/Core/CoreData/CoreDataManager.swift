//
//  CodeDataManager.swift
//  BreakingBad
//
//  Created by Ali Rıza İLHAN on 2.12.2022.
//
import UIKit
import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    private let managedContext: NSManagedObjectContext!
 
    private init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedContext = appDelegate.persistentContainer.viewContext
    }
    func addGameToFavorites(newGame: GameModel) {
        let entity = NSEntityDescription.entity(forEntityName: "Game", in: managedContext)!
        let game = NSManagedObject(entity: entity, insertInto: managedContext)
        game.setValue(newGame.name, forKeyPath: "name")
        game.setValue(newGame.backgroundImage, forKeyPath: "backgroundImage")
        game.setValue(newGame.id, forKeyPath: "id")
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func removeGameFromFavorites(gameId: Int) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Game")
        fetchRequest.predicate = NSPredicate(format: "%K = %d", "id", gameId)
        if let notes = try? managedContext.fetch(fetchRequest) {
            for note in notes {
                managedContext.delete(note)
            }
            do {
                try managedContext.save()
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    func removeAllGamesFromFavorites() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Game")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try managedContext.execute(batchDeleteRequest)

        } catch {
            // Error Handling
        }
    }
    func updateGame(gameModel: GameModel) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Game")
        fetchRequest.predicate = NSPredicate(format: "id == %@", gameModel.id!)
        
        do {
            let games = try managedContext.fetch(fetchRequest)
            let game = games[0]
            game.setValue(gameModel.name, forKeyPath: "name")
            game.setValue(gameModel.backgroundImage, forKeyPath: "backgroundImage")
            game.setValue(gameModel.id, forKeyPath: "id")
            try managedContext.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    func getGamesFromFavorites() -> [Game] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Game")
        do {
            let notes = try managedContext.fetch(fetchRequest)
            return notes as! [Game]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return []
    }
    func saveNote(newNote: UserNoteModel) -> Note? {
        let entity = NSEntityDescription.entity(forEntityName: "Note", in: managedContext)!
        let note = NSManagedObject(entity: entity, insertInto: managedContext)
        note.setValue(newNote.gameName, forKeyPath: "gameName")
        note.setValue(newNote.date, forKeyPath: "date")
        note.setValue(newNote.userNote, forKeyPath: "userNote")
        note.setValue(newNote.id, forKey: "id")
        do {
            try managedContext.save()
            return note as? Note
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        return nil
    }
    
    func removeNote(noteId: UUID) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Note")
        fetchRequest.predicate = NSPredicate(format: "id == %@", noteId as CVarArg)
        if let notes = try? managedContext.fetch(fetchRequest) {
            for note in notes {
                managedContext.delete(note)
            }
            do {
                try managedContext.save()
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    func removeAll() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try managedContext.execute(batchDeleteRequest)

        } catch {
            // Error Handling
        }
    }
    func updateNote(noteModel: UserNoteModel) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Note")
        fetchRequest.predicate = NSPredicate(format: "id == %@", noteModel.id as CVarArg)
        
        do {
            let notes = try managedContext.fetch(fetchRequest)
            let note = notes[0]
            note.setValue(noteModel.gameName, forKeyPath: "gameName")
            note.setValue(noteModel.date, forKeyPath: "date")
            note.setValue(noteModel.userNote, forKeyPath: "userNote")
            note.setValue(noteModel.id, forKey: "id")
            try managedContext.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    func getNotes() -> [Note] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Note")
        do {
            let notes = try managedContext.fetch(fetchRequest)
            return notes as! [Note]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return []
    }
    
    
}
