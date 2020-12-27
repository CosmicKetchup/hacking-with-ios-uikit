//
//  AddCommentsViewController.swift
//  p33.whats-that-whistle
//
//  Created by Matt Brown on 12/26/20.
//

import UIKit

final class AddCommentsViewController: UIViewController {
    private enum ViewMetrics {
        static let backgroundColor = UIColor.systemBackground
        static let textViewFont = UIFont.preferredFont(forTextStyle: .body)
    }
    
    private let genre: Genre
    private let placeholderText = "If you have any additional comments that may help others identify your tune, enter them here."
    
    private lazy var textView: UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = ViewMetrics.textViewFont
        view.text = placeholderText
        return view
    }()
    
    init(genre: Genre) {
        self.genre = genre
        super.init(nibName: nil, bundle: nil)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        navigationItem.title = "Add Comments"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .plain, target: self, action: #selector(submitButtonTapped))
        
        view.backgroundColor = ViewMetrics.backgroundColor
        textView.delegate = self
        
        [textView].forEach { view.addSubview($0) }
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            textView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
        ])
    }
}

extension AddCommentsViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholderText {
            textView.text = ""
        }
    }
}

extension AddCommentsViewController {
    @objc private func submitButtonTapped() {
        guard let userEntry = textView.text else { return }
        let userComment = (userEntry != placeholderText) ? userEntry : ""
        let submitVC = SubmitViewController(for: genre, comment: userComment)
        navigationController?.pushViewController(submitVC, animated: true)
    }
}
