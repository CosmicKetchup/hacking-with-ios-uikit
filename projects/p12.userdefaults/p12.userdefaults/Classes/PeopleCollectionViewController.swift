//
//  PeopleCollectionViewController.swift
//  p12.userdefaults
//
//  Created by Matt Brown on 12/8/19.
//  Copyright © 2019 Matt Brown. All rights reserved.
//

import UIKit

func documentsDirectory() -> URL {
    FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
}

final class PeopleCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private enum ViewMetrics {
        static let backgroundColor = UIColor.lightGray
        static let sectionInsets = UIEdgeInsets(top: 10.0, left: 35.0, bottom: 10.0, right: 35.0)
        static let personCellSize = CGSize(width: 140.0, height: 180.0)
        static let personCellSpacing: CGFloat = 15.0
        static let chosenImageCompressionQuality: CGFloat = 0.8
    }
    
    private var people = [Person]()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        setupView()
    }
    
    private func loadData() {
        let defaults = UserDefaults.standard
        
        if let savedData = defaults.object(forKey: "savedPeople") as? Data {
            do {
                people = try JSONDecoder().decode([Person].self, from: savedData)
            }
            catch {
                print("Failed to load saved people.")
            }
        }
        
        // MARK: - NSCoding Example (Loading)
//        if let savedData = defaults.object(forKey: "savedPeople") as? Data,
//            let savedPeople = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedData) as? [Person] {
//            people = savedPeople
//        }
    }
    
    private func setupView() {
        collectionView.register(PersonCell.self, forCellWithReuseIdentifier: PersonCell.reuseIdentifier)
        navigationItem.title = "Project 12"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "exclamationmark.shield"), style: .plain, target: self, action: #selector(demoButtonTapped))
        collectionView.backgroundColor = ViewMetrics.backgroundColor
        
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else { return }
        layout.sectionInset = ViewMetrics.sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        ViewMetrics.personCellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        ViewMetrics.personCellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        ViewMetrics.personCellSpacing
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        people.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PersonCell.reuseIdentifier, for: indexPath) as! PersonCell
        let person = people[indexPath.item]
        cell.configureFor(name: person.name, imagePath: person.profilePicture)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedCell = collectionView.cellForItem(at: indexPath) else { return }
        let person = people[indexPath.item]
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.modalPresentationStyle = .popover
        alert.popoverPresentationController?.sourceView = selectedCell
        alert.popoverPresentationController?.sourceRect = CGRect(x: selectedCell.bounds.minX, y: selectedCell.bounds.midY, width: selectedCell.bounds.width, height: 0)
        alert.popoverPresentationController?.permittedArrowDirections = [.left, .right]
        
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self, indexPath] _ in
            self?.people.remove(at: indexPath.item)
            self?.collectionView.deleteItems(at: [indexPath])
            self?.saveData()
        }))
        
        alert.addAction(UIAlertAction(title: "Rename", style: .default, handler: { [weak self, indexPath, person] _ in
            let renameAlert = UIAlertController(title: "Rename Person", message: nil, preferredStyle: .alert)
            renameAlert.addTextField { textField in
                textField.text = person.name
            }
            
            renameAlert.addAction(UIAlertAction(title: "OK", style: .destructive) { [renameAlert] _ in
                guard let textFields = renameAlert.textFields, let userEntry = textFields[0].text else { return }
                person.name = userEntry
                self?.collectionView.reloadItems(at: [indexPath])
                self?.saveData()
            })
            renameAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self?.present(renameAlert, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        let imageName = UUID().uuidString
        let imagePath = documentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: ViewMetrics.chosenImageCompressionQuality) {
            try? jpegData.write(to: imagePath)
        }
        
        let person = Person(name: "Unknown", imagePath: imagePath)
        people.append(person)
        collectionView.reloadData()
        dismiss(animated: true)
    }
    
    private func saveData() {
        let defaults = UserDefaults.standard
        if let savedData = try? JSONEncoder().encode(people) {
            defaults.set(savedData, forKey: "savedPeople")
        }
        else {
            print("Failed to save people.")
        }
        
        // MARK: - NSCoding Example (Saving)
//        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: people, requiringSecureCoding: false) {
//            defaults.set(savedData, forKey: "savedPeople")
//        }
    }
}

extension PeopleCollectionViewController {
    @objc func addButtonTapped() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        #if !targetEnvironment(simulator)
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: takePhoto(_:)))
        #endif
        
        alert.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: choosePhoto(_:)))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(alert, animated: true)
    }
    
    fileprivate func takePhoto(_ action: UIAlertAction? = nil) {
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
    
    @objc fileprivate func demoButtonTapped() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Load Demo Content", style: .destructive, handler: loadDemoPrompt))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.popoverPresentationController?.barButtonItem = navigationItem.leftBarButtonItem
        present(alert, animated: true)
    }
    
    fileprivate func loadDemoPrompt(_ action: UIAlertAction? = nil) {
        let alert = UIAlertController(title: "Load Demo Content", message: "This will remove existing entries.\nAre you sure?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Confirm", style: .destructive, handler: loadDemoContent))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    fileprivate func loadDemoContent(_ action: UIAlertAction? = nil) {
        guard let rootPath = Bundle.main.resourcePath, let files = try? FileManager.default.contentsOfDirectory(atPath: rootPath) else { return }
        people.removeAll(keepingCapacity: true)
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            for file in files where file.hasPrefix("nssl") {
                let imageName = UUID().uuidString
                let imagePath = documentsDirectory().appendingPathComponent(imageName)
                if let jpegData = UIImage(named: file)?.jpegData(compressionQuality: ViewMetrics.chosenImageCompressionQuality) {
                    try? jpegData.write(to: imagePath)
                }
                let storm = Person(name: file, imagePath: imagePath)
                self?.people.append(storm)
            }
            
            self?.saveData()
            DispatchQueue.main.async { self?.collectionView.reloadData() }
        }
    }
}
