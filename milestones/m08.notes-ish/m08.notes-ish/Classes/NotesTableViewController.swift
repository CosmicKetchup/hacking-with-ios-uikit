//
//  NotesTableViewController.swift
//  m08.notes-ish
//
//  Created by Matt Brown on 1/18/20.
//  Copyright © 2020 Matt Brown. All rights reserved.
//

import UIKit

final class NotesTableViewController: UITableViewController, NoteManagementDelegate {
    
    private enum ViewMetrics {
        static let backgroundColor = UIColor(red: 1.0, green: 252/255, blue: 146/255, alpha: 1.0)
    }
    
    private let defaults = UserDefaults.standard
    private let savedNotesKey = "savedNotes"
    private let noteCellId = "NoteCell"
    private var notes = [Note]()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        setupView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        saveData()
        tableView.reloadData()
    }
    
    private func setupView() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Milestone 08"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: nil, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "compose"), style: .plain, target: self, action: #selector(composeTapped))
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: noteCellId)
        tableView.backgroundColor = ViewMetrics.backgroundColor
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: noteCellId)
        let note = notes[indexPath.row]
        
        cell.backgroundColor = .clear
        cell.textLabel?.text = note.title
        cell.detailTextLabel?.text = note.dateModified
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let note = notes[indexPath.row]
        let detailVC = DetailViewController(configureFor: note)
        detailVC.noteDelegate = self
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: nil) { [weak self] _, _, isFinished in
            let alert = UIAlertController(title: "Delete Note", message: "This action cannot be undone.\nAre you sure?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            alert.addAction(UIAlertAction(title: "Confirm", style: .destructive) { _ in
                self?.notes.remove(at: indexPath.row)
                self?.saveData()
                self?.tableView.deleteRows(at: [indexPath], with: .fade)
            })
            
            self?.present(alert, animated: true)
            isFinished(true)
        }
        delete.image = UIImage(named: "trash")
        
        let swipeActions = UISwipeActionsConfiguration(actions: [delete])
        swipeActions.performsFirstActionWithFullSwipe = true
        return swipeActions
    }
    
    func didUpdateNote(_ note: Note) {
        saveData()
        tableView.reloadData()
    }
    
    func didDeleteNote(_ note: Note) {
        guard let index = notes.firstIndex(of: note) else { return }
        notes.remove(at: index)
        saveData()
        tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
}

extension NotesTableViewController {
    @objc fileprivate func composeTapped() {
        let alert = UIAlertController(title: "Edit Note Title", message: "Enter a title for your note", preferredStyle: .alert)
        alert.addTextField { [weak self] textField in
            guard let noteCount = self?.notes.count else { return }
            textField.text = "New Note \(noteCount + 1)"
            textField.clearsOnBeginEditing = true
            textField.clearButtonMode = .always
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            guard let textField = alert.textFields?.first, let userEntry = textField.text else { return }
            let newNote = Note(title: userEntry.isEmpty ? "Untitled Note" : userEntry)
            self?.notes.append(newNote)
            self?.saveData()
            
            let detailVC = DetailViewController(configureFor: newNote)
            detailVC.noteDelegate = self
            self?.navigationController?.pushViewController(detailVC, animated: true)
        })
        present(alert, animated: true)
    }
    
    @objc fileprivate func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = tableView.convert(keyboardScreenEndFrame, from: tableView.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            tableView.contentSize = .zero
        }
        else {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
        }
        
        tableView.scrollIndicatorInsets = tableView.contentInset
    }
}

extension NotesTableViewController {
    func index(of note: Note) -> Int? {
        notes.firstIndex(of: note)
    }
    
    func removeNote(at index: Int) {
        notes.remove(at: index)
        saveData()
    }
}

// MARK: - Data Management
extension NotesTableViewController {
    func saveData() {
        if let savedData = try? JSONEncoder().encode(notes) {
            defaults.set(savedData, forKey: savedNotesKey)
        }
        else {
            print("Failed to save notes.")
        }
    }
    
    fileprivate func loadData() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let savedNotesKey = self?.savedNotesKey, let savedData = self?.defaults.object(forKey: savedNotesKey) as? Data else { return }
            
            do {
                self?.notes = try JSONDecoder().decode([Note].self, from: savedData)
                DispatchQueue.main.async { self?.tableView.reloadData() }
            }
            catch {
                print("Failed to load notes.")
            }
        }
    }
}
