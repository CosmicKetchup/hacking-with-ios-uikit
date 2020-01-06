//
//  PhotoTableViewController.swift
//  m05.photo-journal
//
//  Created by Matt Brown on 1/2/20.
//  Copyright © 2020 Matt Brown. All rights reserved.
//

import UIKit

final class PhotoTableViewController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var userPhotosDataKey = "userPhotos"
    var userPhotos = [UserPhoto]()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadPhotos()
        setupView()
    }

    private func setupView() {
        navigationItem.title = "Milestone 05"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))

        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)

        tableView.register(PhotoCell.self, forCellReuseIdentifier: PhotoCell.reuseIdentifier)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        userPhotos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PhotoCell.reuseIdentifier, for: indexPath) as? PhotoCell else { fatalError() }
        let photo = userPhotos[indexPath.item]
        cell.configure(for: photo)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userPhoto = userPhotos[indexPath.row]
        let photoDetailView = PhotoDetailViewController(photo: userPhoto)
        navigationController?.pushViewController(photoDetailView, animated: true)
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        let imageName = UUID().uuidString
        let imagePath = documentsDirectory().appendingPathComponent(imageName)

        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
            let photo = UserPhoto(filename: imageName, caption: nil)
            userPhotos.append(photo)
            tableView.reloadData()
            dismiss(animated: true) { [weak self] in
                self?.promptForCaption()
            }
        }
    }
}

extension PhotoTableViewController {
    private func saveData() {
        let defaults = UserDefaults.standard
        if let savedData = try? JSONEncoder().encode(userPhotos) {
            defaults.set(savedData, forKey: userPhotosDataKey)
        }
    }

    fileprivate func loadPhotos() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let defaults = UserDefaults.standard
            guard let dataKey = self?.userPhotosDataKey, let savedData = defaults.object(forKey: dataKey) as? Data else { print("No saved data found."); return }

            do {
                self?.userPhotos = try JSONDecoder().decode([UserPhoto].self, from: savedData)
                DispatchQueue.main.async { self?.tableView.reloadData() }
            }
            catch {
                print("Failed to load saved photos.")
            }
        }
    }

    @objc fileprivate func handleRefresh() {
        tableView.reloadData()
        saveData()
        DispatchQueue.main.async { [weak self] in self?.tableView.refreshControl?.endRefreshing() }
    }

    @objc fileprivate func addButtonTapped() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        #if !targetEnvironment(simulator)
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: takePhoto))
        #endif

        alert.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: choosePhoto))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(alert, animated: true)
    }

    private func takePhoto(_ action: UIAlertAction? = nil) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        picker.allowsEditing = true
        present(picker, animated: true)
    }

    fileprivate func choosePhoto(_ action: UIAlertAction? = nil) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }

    fileprivate func promptForCaption() {
        let alert = UIAlertController(title: "Enter Caption", message: "Provide a description for your photo.", preferredStyle: .alert)
        alert.addTextField()
        alert.addAction(UIAlertAction(title: "Submit", style: .default) { [weak self] _ in
            if let textFields = alert.textFields, let userEntry = textFields.first?.text, let photo = self?.userPhotos.last {
                guard let index = self?.userPhotos.firstIndex(of: photo) else { return }
                photo.updateCaption(to: userEntry)
                self?.saveData()
                self?.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
            }
        })
        present(alert, animated: true)
    }
}

func documentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}
