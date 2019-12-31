//
//  ShoppingListTableViewController.swift
//  m03.shopping-list
//
//  Created by Matt Brown on 10/9/19.
//  Copyright © 2019 Matt Brown. All rights reserved.
//

import UIKit

class ShoppingListTableViewController: UITableViewController {
    
    private let itemCellIdentifier = "ListItemCell"
    private var shoppingItems = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        shoppingItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: itemCellIdentifier, for: indexPath)
        let itemName = shoppingItems[indexPath.item]
        cell.textLabel?.text = itemName
        return cell
    }
    
    private func setupView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: itemCellIdentifier)
        navigationItem.title = "Milestone 03"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let addItemButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForItemName))
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        navigationItem.rightBarButtonItems = [addItemButton, shareButton]
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clearTapped))
    }
}

extension ShoppingListTableViewController {
    @objc fileprivate func promptForItemName(_ action: UIAlertAction? = nil) {
        let alert = UIAlertController(title: "Enter Item Name", message: nil, preferredStyle: .alert)
        alert.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak alert] _ in
            if let textFields = alert?.textFields, let userEntry = textFields[0].text {
                self?.addItem(userEntry.lowercased())
            }
        }
        alert.addAction(submitAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    private func addItem(_ itemName: String) {
        if shoppingItems.contains(itemName) {
            let alert = UIAlertController(title: "Duplicate Item", message: "Your list shopping list already contains this item.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            alert.addAction(UIAlertAction(title: "New Item", style: .default, handler: promptForItemName(_:)))
            present(alert, animated: true)
        }
        else {
            shoppingItems.insert(itemName, at: 0)
            let indexPath = IndexPath(item: 0, section: 0)
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    @objc fileprivate func shareTapped() {
        let shoppingList = shoppingItems.joined(separator: "\n")
        let alert = UIActivityViewController(activityItems: [shoppingList], applicationActivities: [])
        alert.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItems?[1]
        present(alert, animated: true)
    }
    
    @objc fileprivate func clearTapped() {
        let alert = UIAlertController(title: "Clear List", message: "Are you sure? This cannot be undone.", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Confirm", style: .destructive, handler: { [weak self] _ in
            self?.shoppingItems.removeAll(keepingCapacity: true)
            self?.tableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.popoverPresentationController?.barButtonItem = navigationItem.leftBarButtonItem
        present(alert, animated: true)
    }
}

