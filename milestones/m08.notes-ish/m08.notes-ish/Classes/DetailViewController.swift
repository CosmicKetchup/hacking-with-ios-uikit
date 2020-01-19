//
//  DetailViewController.swift
//  m08.notes-ish
//
//  Created by Matt Brown on 1/18/20.
//  Copyright © 2020 Matt Brown. All rights reserved.
//

import UIKit

protocol NoteManagementDelegate {
    func didUpdateNote(_ note: Note)
    func didDeleteNote(_ note: Note)
}

final class DetailViewController: UIViewController, UITextViewDelegate {
    
    private enum ViewMetrics {
        static let backgroundColor = UIColor(red: 1.0, green: 252/255, blue: 146/255, alpha: 1.0)
        static let textViewFont = UIFont.preferredFont(forTextStyle: .body)
    }
    
    var noteDelegate: NoteManagementDelegate!
    private let note: Note
    private let textView: UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        
        view.font = ViewMetrics.textViewFont
        view.adjustsFontForContentSizeCategory = true
        return view
    }()
    
    init(configureFor note: Note) {
        self.note = note
        super.init(nibName: nil, bundle: nil)
        textView.delegate = self
        textView.text = note.content
        
        
        note.updateModifiedDate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noteDelegate.didUpdateNote(note)
        setupView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    private func setupView() {
        navigationItem.title = note.title
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "ellipsis"), style: .plain, target: self, action: #selector(moreTapped))
        
        view.backgroundColor = ViewMetrics.backgroundColor
        
        [textView].forEach { view.addSubview($0) }
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            textView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            textView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            textView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
        ])
    }
}

extension DetailViewController {
    @objc fileprivate func moreTapped() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: deleteNote))
        alert.addAction(UIAlertAction(title: "Edit Title", style: .default, handler: editTitle))
        alert.addAction(UIAlertAction(title: "Share", style: .default, handler: shareNote))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(alert, animated: true)
    }
    
    fileprivate func editTitle(_ action: UIAlertAction) {
        let alert = UIAlertController(title: "Enter New Note Name", message: nil, preferredStyle: .alert)
        
        alert.addTextField { [weak self] textField in
            textField.text = self?.note.title
            textField.allowsEditingTextAttributes = false
            textField.clearsOnBeginEditing = false
            textField.clearButtonMode = .always
        }
        
        alert.addAction(UIAlertAction(title: "Submit", style: .default) { [weak self] _ in
            guard let textField = alert.textFields?.first, let userEntry = textField.text else { return }
            self?.note.setTitle(to: userEntry)
            self?.navigationItem.title = userEntry
            NotesTableViewController().saveData()
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    fileprivate func deleteNote(_ action: UIAlertAction) {
        let alert = UIAlertController(title: "Delete Note", message: "This cannot be undone.\nAre you sure?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Confirm", style: .destructive) { [weak self] _ in
            guard let note = self?.note else { return }
            self?.noteDelegate.didDeleteNote(note)
            self?.navigationController?.popViewController(animated: true)
        })
        present(alert, animated: true)
    }
    
    fileprivate func shareNote(_ action: UIAlertAction? = nil) {
        let alert = UIActivityViewController(activityItems: [note.title, note.content], applicationActivities: [])
        alert.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(alert, animated: true)
    }
    
    @objc fileprivate func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            textView.contentSize = .zero
        }
        else {
            textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
        }
        
        textView.scrollIndicatorInsets = textView.contentInset
        let selectedRange = textView.selectedRange
        textView.scrollRangeToVisible(selectedRange)
    }
}

