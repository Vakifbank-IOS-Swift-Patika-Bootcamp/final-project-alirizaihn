//
//  CreateNoteViewController.swift
//  GameCollector
//
//  Created by Ali Rıza İLHAN on 16.12.2022.
//

import UIKit

protocol NewNotesDelegate {
    func createdNewNote()
}

final class CreateNoteViewController: BaseViewController {

    @IBOutlet private weak var gameNameLabel: UITextField!
    @IBOutlet private weak var noteTextView: UITextView!
    @IBOutlet private var bgView: UIView!
    var note: Note?
    private var userNote = UserNoteModel(gameName: "", userNote: "", date: Date(), id: UUID())
    private var viewModel: CreateNoteViewProtocol = CreateNoteViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        configureUI()
        
        // Do any additional setup after loading the view.
    }
    
    func configureUI() {
        if note != nil {
            gameNameLabel.text = note?.gameName
            noteTextView.text = note?.userNote
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        userNote.userNote = noteTextView.text ?? ""
        userNote.gameName = gameNameLabel.text ?? ""
        viewModel.saveNote(note: note, userNoteModel: userNote)
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        bgView.endEditing(true)
        view.endEditing(true)
    }
    
}

extension CreateNoteViewController: CreateNoteViewDelegate {
    func noteSaved() {
        NotificationCenter.default.post(name: NSNotification.Name("updateNotesList"), object: nil)
        dismiss(animated: true)
    }
    
    func onError(message: String) {
        self.showErrorAlert(message: message) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
}
