//
//  ImageViewController.swift
//  p30.instruments
//
//  Created by TwoStraws on 20/08/2016.
//  Copyright (c) 2016 TwoStraws. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
	private var owner: SelectionViewController
    private var selectedImageFilename: String
	var animTimer: Timer!

    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.alpha = 0
        view.image = UIImage(contentsOfFile: documentsDirectory().appendingPathComponent(selectedImageFilename).path)
        return view
    }()
    
    init(owner: SelectionViewController, filename: String) {
        self.owner = owner
        self.selectedImageFilename = filename
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        animTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { [weak self] timer in
            self?.imageView.transform = CGAffineTransform.identity
            UIView.animate(withDuration: 3) {
                self?.imageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }
        }
    }
    
    private func setupView() {
        view.backgroundColor = UIColor.black

        [imageView].forEach { view.addSubview($0) }
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		imageView.alpha = 0

		UIView.animate(withDuration: 3) { [weak self] in
            self?.imageView.alpha = 1.0
		}
	}

	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		let defaults = UserDefaults.standard
		var currentVal = defaults.integer(forKey: selectedImageFilename)
		currentVal += 1

		defaults.set(currentVal, forKey: selectedImageFilename)
		owner.isDirty = true
	}
}
