//
//  ComicListViewControllet.swift
//  MarvelComicViewer
//
//  Created by Kieran Barry on 8/19/21.
//

import Foundation
import UIKit

class ComicListViewController: UITableViewController {
    
    private var comicList: [Comic]? {
        didSet {
            tableView.reloadData()
        }
    }

    
    // MARK: UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let comicList = comicList {
            return comicList.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.comicCellIdentifier, for: indexPath)
        if let comic = comicList?[indexPath.row] {

            cell.textLabel?.text = comic.title
            cell.detailTextLabel?.text = "Issue: \(comic.issueNumber)"
//            // TODO: add image
        }
        
        return cell
    }
    
    
    // MARK: Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.comicDetailSegue {
            if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
                let comicDetailVC = segue.destination as? ComicDetailViewController
                comicDetailVC?.comic = comicList?[indexPath.row]
            }
        }
        // TODO: pass along comic info
    }
    
    
    // MARK: Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAllComics()
    }
    
    
    
    // MARK: Network Requests
    
    /**
     Launces fetch request for comic data with Constants.comicId from Marvel API and updates UI based on result.
     On success, launches image fetch request. On failure, displays network error views.
     */
    private func fetchAllComics() {
        MarvelAPIManager.shared.fetchComics() { result in
            DispatchQueue.main.async { [ weak self ] in
                switch result {

                case .success(let comicList):
                    self?.comicList = comicList.comics
                case .failure(_):
                    // TODO: Handle error
//                    self?.displayNetworkError(error)
                    break
                }
            }
        }
    }
}
