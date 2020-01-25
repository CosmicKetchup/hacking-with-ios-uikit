//
//  RootCollectionViewController.swift
//  m10.meme-generator
//
//  Created by Matt Brown on 1/24/20.
//  Copyright © 2020 Matt Brown. All rights reserved.
//

import UIKit

private func documentsDirectory() -> URL {
    FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
}

final class RootCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private enum ViewMetrics {
        static let backgroundColor = UIColor.white
        static let imageCellSize = CGSize(width: 145, height: 145)
        static let interItemSpacing: CGFloat = 25.0
        static let sectionInsets = UIEdgeInsets(top: 10, left: 25, bottom: 10, right: 25)
    }
    
    private var memes = [Meme]()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadMemes()
        setupView()
    }

    private func setupView() {
        overrideUserInterfaceStyle = .light
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Milestone 10"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(cameraButtonTapped))
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
        
        collectionView.backgroundColor = ViewMetrics.backgroundColor
        collectionView.register(MemeCell.self, forCellWithReuseIdentifier: MemeCell.reuseIdentifier)
        
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionInset = ViewMetrics.sectionInsets
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        memes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        ViewMetrics.imageCellSize
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MemeCell.reuseIdentifier, for: indexPath) as? MemeCell else { fatalError() }
        let meme = memes[indexPath.item]
        cell.configure(for: meme)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let meme = memes[indexPath.item]
        guard let memeImage = UIImage(named: meme.filename) else { return }
        let detailVC = DetailViewController(for: memeImage, title: meme.title)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension RootCollectionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        dismiss(animated: true)
        let detailVC = DetailViewController(for: image)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension RootCollectionViewController {
    fileprivate func loadMemes() {
        guard let rootPath = Bundle.main.resourcePath, let files = try? FileManager.default.contentsOfDirectory(atPath: rootPath) else { return }
        for file in files where file.hasPrefix("meme_") {
            let newMeme = Meme(filename: file)
            memes.append(newMeme)
        }
        
        memes.sort(by: { $0.title > $1.title })
        DispatchQueue.main.async { [weak self] in self?.collectionView.reloadData() }
    }
    
    @objc fileprivate func cameraButtonTapped() {
        let alert = UIAlertController(title: "Select Image Source", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Photo Gallery", style: .default, handler: importPhoto))
        #if !targetEnvironment(simulator)
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: takePhoto))
        #endif
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(alert, animated: true)
    }
    
    private func importPhoto(action: UIAlertAction) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    private func takePhoto(action: UIAlertAction) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        picker.allowsEditing = true
        present(picker, animated: true)
    }
}

