//
//  SubmitViewController.swift
//  p33.whats-that-whistle
//
//  Created by Matt Brown on 12/26/20.
//

import CloudKit
import UIKit

final class SubmitViewController: UIViewController {
    private enum ViewMetrics {
        static let backgroundColor = UIColor.systemGray
        static let successfulBackgroundColor = UIColor.systemGreen
        
        static let statusLabelTextColor = UIColor.white
        static let statusLabelFont = UIFont.preferredFont(forTextStyle: .title1)
        
        static let contentStackSpacing: CGFloat = 10.0
    }
    
    static let whistleRecordIdentifier = "Whistles"
    private let genre: Genre
    private let comment: String
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.font = ViewMetrics.statusLabelFont
        label.text = "Submitting..."
        label.textColor = ViewMetrics.statusLabelTextColor
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.hidesWhenStopped = true
        view.startAnimating()
        return view
    }()
    
    private lazy var contentStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [statusLabel, activityIndicator])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = ViewMetrics.contentStackSpacing
        stack.distribution = .fillEqually
        stack.alignment = .center
        stack.axis = .vertical
        return stack
    }()
    
    init(for genre: Genre, comment: String) {
        self.genre = genre
        self.comment = comment
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        submitWhistle()
    }
    
    private func setupView() {
        navigationItem.title = ""
        navigationItem.hidesBackButton = true
        
        view.backgroundColor = ViewMetrics.backgroundColor
        
        [contentStack].forEach { view.addSubview($0) }
        NSLayoutConstraint.activate([
            contentStack.centerYAnchor.constraint(equalTo: view.layoutMarginsGuide.centerYAnchor),
            contentStack.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
        ])
    }
    
    private func submitWhistle() {
        let whistleRecord = CKRecord(recordType: SubmitViewController.whistleRecordIdentifier)
        whistleRecord["genre"] = genre as CKRecordValue
        whistleRecord["comment"] = comment as CKRecordValue
        
        let audioURL = RecordWhistleViewController.whistleURL()
        let whistleAsset = CKAsset(fileURL: audioURL)
        whistleRecord["audio"] = whistleAsset
        
        CKContainer.default().publicCloudDatabase.save(whistleRecord) { (record, error) in
            DispatchQueue.main.async { [weak self] in
                if let error = error {
                    self?.statusLabel.text = "Error: \(error.localizedDescription)"
                }
                else {
                    self?.view.backgroundColor = ViewMetrics.successfulBackgroundColor
                    self?.statusLabel.text = "Upload Complete"
                    RootTableViewController.isDirty = true
                }
                
                self?.activityIndicator.stopAnimating()
                self?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self?.doneButtonTapped))
            
            }
        }
    }
}

extension SubmitViewController {
    @objc private func doneButtonTapped() {
        let _ = navigationController?.popToRootViewController(animated: true)
    }
}
