//
//  DetailViewController.swift
//  m10.meme-generator
//
//  Created by Matt Brown on 1/24/20.
//  Copyright © 2020 Matt Brown. All rights reserved.
//

import UIKit
import CoreGraphics

class DetailViewController: UIViewController {
    
    fileprivate enum ViewMetrics {
        static let backgroundColor = UIColor.lightGray
        
        static let paragraphStyle: NSMutableParagraphStyle = {
            let pgStyle = NSMutableParagraphStyle()
            pgStyle.alignment = .center
            pgStyle.lineBreakMode = .byWordWrapping
            pgStyle.lineSpacing = .zero
            return pgStyle
        }()
        
        static let buttonMargins = UIEdgeInsets(top: 8.0, left: 16.0, bottom: 8.0, right: 16.0)
        static let buttonTitleColor = UIColor.white
        static let buttonBackgroundColor = UIColor.systemBlue
        static let buttonFont = UIFont.boldSystemFont(ofSize: 18.0)
        static let buttonCornerRadius: CGFloat = 7.0
        static let buttonBorderWidth: CGFloat = 1.0
        static let buttonBorderColor = UIColor.darkGray.cgColor
        
        static let textFieldAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Arial-BoldMT", size: 36.0) as Any,
            .strokeColor: UIColor.black,
            .strokeWidth: -4.0,
            .paragraphStyle: paragraphStyle,
            .foregroundColor: UIColor.white,
        ]
    }
    
    private let originalImage: UIImage
    private var existingTopCaption: String?
    private var existingBottomCaption: String?
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.image = originalImage
        view.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        return view
    }()
    
    private let captionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentEdgeInsets = ViewMetrics.buttonMargins
        button.addTarget(self, action: #selector(showCaptionPrompt), for: .touchUpInside)
        
        button.titleLabel?.font = ViewMetrics.buttonFont
        button.setTitle("Modify Image Text", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = ViewMetrics.buttonBackgroundColor
        
        button.layer.cornerRadius = ViewMetrics.buttonCornerRadius
        button.layer.borderWidth = ViewMetrics.buttonBorderWidth
        button.layer.borderColor = ViewMetrics.buttonBorderColor
        return button
    }()
    
    init(for image: UIImage, title: String? = nil) {
        self.originalImage = image
        super.init(nibName: nil, bundle: nil)
        
        navigationItem.title = title ?? "Milestone 10"
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
        showCaptionPrompt()
    }
    
    private func setupView() {
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        view.backgroundColor = ViewMetrics.backgroundColor
        
        [imageView, captionButton].forEach { view.addSubview($0) }
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.leadingAnchor.constraint(greaterThanOrEqualToSystemSpacingAfter: view.layoutMarginsGuide.leadingAnchor, multiplier: 1.0),
            view.layoutMarginsGuide.trailingAnchor.constraint(greaterThanOrEqualToSystemSpacingAfter: imageView.trailingAnchor, multiplier: 1.0),
            
            captionButton.topAnchor.constraint(greaterThanOrEqualToSystemSpacingBelow: imageView.bottomAnchor, multiplier: 3.0),
            captionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            view.layoutMarginsGuide.bottomAnchor.constraint(equalToSystemSpacingBelow: captionButton.bottomAnchor, multiplier: 3.0),
        ])
    }
}

extension DetailViewController {
    @objc fileprivate func shareTapped() {
        guard let image = imageView.image else { return }
        let alert = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        alert.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(alert, animated: true)
    }
    
    @objc fileprivate func showCaptionPrompt() {
        let alert = UIAlertController(title: "Enter Caption", message: nil, preferredStyle: .alert)
        alert.addTextField { [weak self] textField in
            textField.placeholder = "TOP TEXT"
            textField.text = self?.existingTopCaption ?? nil
            textField.clearsOnBeginEditing = false
            textField.clearsOnInsertion = false
            textField.clearButtonMode = .always
        }
        
        alert.addTextField { [weak self] textField in
            textField.placeholder = "BOTTOM TEXT"
            textField.text = self?.existingBottomCaption ?? nil
            textField.clearsOnBeginEditing = false
            textField.clearsOnInsertion = false
            textField.clearButtonMode = .always
        }
        
        alert.addAction(UIAlertAction(title: "Submit", style: .default) { [weak self] _ in
            guard let topText = alert.textFields?.first?.text, let botText = alert.textFields?.last?.text else { return }
            guard let currentImage = self?.originalImage else { return }
            
            self?.existingTopCaption = topText
            self?.existingBottomCaption = botText
            
            let renderer = UIGraphicsImageRenderer(size: currentImage.size)
            self?.imageView.image = renderer.image { ctx in
                let image = currentImage
                image.draw(at: CGPoint(x: 0, y: 0))
                
                let topAttributedString = NSAttributedString(string: topText.uppercased(), attributes: ViewMetrics.textFieldAttributes)
                topAttributedString.draw(
                    with: CGRect(
                        x: 15,
                        y: 15,
                        width: image.size.width - (15 * 2),
                        height: image.size.height / 3),
                    options: .usesLineFragmentOrigin,
                    context: nil)
                
                let botAttributedString = NSAttributedString(string: botText.uppercased(), attributes: ViewMetrics.textFieldAttributes)
                botAttributedString.draw(
                    with: CGRect(
                        x: 0,
                        y: image.size.height - (botAttributedString.size().height * 2),
                        width: image.size.width - (15 * 2),
                        height: image.size.height / 3),
                    options: .usesLineFragmentOrigin,
                    context: nil)
            }
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
}
