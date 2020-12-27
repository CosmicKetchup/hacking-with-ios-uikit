//
//  SelectGenreTableViewController.swift
//  p33.whats-that-whistle
//
//  Created by Matt Brown on 12/26/20.
//

import UIKit

final class SelectGenreTableViewController: UITableViewController {

    static var genres = ["Unknown", "Blues", "Classical", "Electronic", "Jazz", "Metal", "Pop", "Reggae", "R&B", "Rock", "Soul"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(GenreCell.self, forCellReuseIdentifier: GenreCell.reuseIdentifier)
        setupView()
    }
    
    private func setupView() {
        navigationItem.title = "Select Genre"
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        SelectGenreTableViewController.genres.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GenreCell.reuseIdentifier, for: indexPath) as? GenreCell else { fatalError() }
        let genre = SelectGenreTableViewController.genres[indexPath.row]
        cell.configure(for: genre)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath), let genre = cell.textLabel?.text else { return }
        let commentsVC = AddCommentsViewController(genre: genre)
        navigationController?.pushViewController(commentsVC, animated: true)
    }
}
