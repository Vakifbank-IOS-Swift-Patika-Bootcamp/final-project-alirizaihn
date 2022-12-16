//
//  NoteListViewController.swift
//  GameCollector
//
//  Created by Ali Rıza İLHAN on 16.12.2022.
//

import UIKit

final class NoteListViewController: BaseViewController {

    @IBOutlet private weak var userNotesListView: UITableView!{
        didSet {
            userNotesListView.delegate = self
            userNotesListView.dataSource = self
            userNotesListView.estimatedRowHeight = UITableView.automaticDimension
        }
    }
    private var viewModel: NoteListViewProtocol = NoteListViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        userNotesListView.reloadData()
    }

}
extension NoteListViewController : UITableViewDelegate, UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.getNotesCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserNoteTableViewCell", for: indexPath) as? UserNoteTableViewCell,
            let model = viewModel.getNote(at: indexPath.row) else { return UITableViewCell() }
        print("şimdineden\(model)")
        cell.configureCell(userNoteModel: model)
        return cell
        }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let note = viewModel.getNote(at: indexPath.row) {
                viewModel.removeNote(userNote: note)
                userNotesListView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
}
