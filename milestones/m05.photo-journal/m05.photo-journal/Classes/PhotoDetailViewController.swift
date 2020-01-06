//
//  PhotoDetailViewController.swift
//  m05.photo-journal
//
//  Created by Matt Brown on 1/2/20.
//  Copyright © 2020 Matt Brown. All rights reserved.
//

import UIKit

final class PhotoDetailViewController: UIViewController {

    private enum ViewMetrics {
        static let captionLabelFont = UIFont.preferredFont(forTextStyle: .body)
        static let captionLabelTextColor = UIColor.white
        static let captionViewBackgroundColor = UIColor(white: 0, alpha: 0.55)
        static let captionViewInsets = NSDirectionalEdgeInsets(top: 12.0, leading: 24.0, bottom: 12.0, trailing: 24.0)
    }

    private var selectedPhoto: UserPhoto
    private let photoImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        return view
    }()

    private var captionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = ViewMetrics.captionLabelFont
        label.adjustsFontForContentSizeCategory = true
        label.textColor = ViewMetrics.captionLabelTextColor
        label.textAlignment = .center
        return label
    }()

    private lazy var captionView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ViewMetrics.captionViewBackgroundColor
        view.directionalLayoutMargins = ViewMetrics.captionViewInsets

        view.addSubview(captionLabel)
        NSLayoutConstraint.activate([
            captionLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            captionLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            captionLabel.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            captionLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
        ])

        return view
    }()

    override var prefersHomeIndicatorAutoHidden: Bool {
        navigationController?.hidesBarsOnTap ?? false
    }

    init(photo: UserPhoto) {
        self.selectedPhoto = photo
        super.init(nibName: nil, bundle: nil)

        let imagePath = documentsDirectory().appendingPathComponent(photo.filename).path
        guard let userImage = UIImage(contentsOfFile: imagePath) else { print("Unable to locate image file."); return }
        photoImageView.image = userImage

        if photo.caption.isEmpty {
            captionView.isHidden = true
        }
        else {
            captionLabel.text = photo.caption
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }

    private func setupView() {
        navigationItem.title = "Milestone 05"
        navigationItem.largeTitleDisplayMode = .never

        [photoImageView, captionView].forEach { view.addSubview($0) }

        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: view.topAnchor),
            photoImageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            photoImageView.rightAnchor.constraint(equalTo: view.rightAnchor),

            captionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            captionView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            captionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}
