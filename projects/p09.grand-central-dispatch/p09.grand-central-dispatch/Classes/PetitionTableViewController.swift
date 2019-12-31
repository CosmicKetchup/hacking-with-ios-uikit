//
//  PetitionTableViewController.swift
//  p09.grand-central-dispatch
//
//  Created by Matt Brown on 10/10/19.
//  Copyright © 2019 Matt Brown. All rights reserved.
//

import UIKit

enum SearchType: Int {
    case recent = 1, top
    
    var address: String {
        return "https://hackingwithswift.com/samples/petitions-\(self.rawValue).json"
    }
}

final class PetitionTableViewController: UITableViewController {
    
    private let petitionCellIdentifier = "PetitionCell"
    fileprivate var allPetitions = [Petition]()
    fileprivate var filteredPetitions = [Petition]()
    private let searchType: SearchType
    
    fileprivate var isFiltered = false {
        didSet {
            DispatchQueue.main.async { [weak self] in self?.configureLeftBarButtonItem() }
        }
    }
    
    init(type: SearchType) {
        self.searchType = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        loadPetitions()
    }
    
    private func setupView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: petitionCellIdentifier)
        navigationItem.title = "Project 09"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credit", style: .plain, target: self, action: #selector(creditTapped))
        configureLeftBarButtonItem()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredPetitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: petitionCellIdentifier, for: indexPath)
        let targetPetition = filteredPetitions[indexPath.item]
        cell.textLabel?.text = targetPetition.title
        cell.detailTextLabel?.text = targetPetition.body
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let targetPetition = filteredPetitions[indexPath.item]
        let detailVC = PetitionDetailViewController(show: targetPetition)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
    
extension PetitionTableViewController {
    fileprivate func loadPetitions() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            if let self = self, let targetUrl = URL(string: self.searchType.address), let rawData = try? Data(contentsOf: targetUrl) {
                let decoder = JSONDecoder()
                guard let jsonPetitions = try? decoder.decode(Petitions.self, from: rawData) else { self.showConnectionError(); return }
                self.allPetitions = jsonPetitions.results
                self.filteredPetitions = jsonPetitions.results
                
                DispatchQueue.main.async { self.tableView.reloadData() }
            }
        }
    }
    
    private func showConnectionError() {
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(title: "Error Loading Data", message: "Check network connection and try again.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Continue", style: .default))
            self?.present(alert, animated: true)
        }
    }
    
    fileprivate func configureLeftBarButtonItem() {
        if self.isFiltered {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Clear Filter", style: .plain, target: self, action: #selector(self.clearTapped))
        }
        else {
            self.navigationItem.leftBarButtonItem =  UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(self.filterTapped))
        }
    }
    
    @objc fileprivate func clearTapped() {
        isFiltered = false
        filteredPetitions = allPetitions
        DispatchQueue.main.async { [weak self] in self?.tableView.reloadData() }
    }
    
    @objc private func filterTapped() {
        let alert = UIAlertController(title: "Filter by Keyword", message: nil, preferredStyle: .alert)
        alert.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak alert] _ in
            guard let textFields = alert?.textFields, let userEntry = textFields[0].text else { return }
            
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in self?.filterByKeyword(userEntry) }
        }
        
        alert.addAction(submitAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    private func filterByKeyword(_ keyword: String) {
        var filteredResults = [Petition]()
        filteredPetitions.forEach({ petition in
            if petition.title.contains(keyword) || petition.body.contains(keyword) {
                filteredResults.append(petition)
            }
        })
        filteredPetitions = filteredResults
        isFiltered = true
        DispatchQueue.main.async { [weak self] in self?.tableView.reloadData() }
    }
    
    @objc private func creditTapped() {
        let alert = UIAlertController(title: "", message: "All data is sourced from the\nWhitehouse's We The People API.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
