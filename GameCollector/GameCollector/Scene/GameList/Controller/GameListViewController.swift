//
//  ViewController.swift
//  GameCollector
//
//  Created by Ali Rıza İLHAN on 7.12.2022.
//

import UIKit

final class GameListViewController: UIViewController {

    @IBOutlet private weak var gameListTableView: UITableView! {
        didSet {
            gameListTableView.delegate = self
            gameListTableView.dataSource = self
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

extension GameListViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("item selected")
    }
    
     
}
