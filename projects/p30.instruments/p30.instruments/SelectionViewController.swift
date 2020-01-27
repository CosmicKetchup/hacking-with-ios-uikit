//
//  SelectionViewController.swift
//  p30.instruments
//
//  Created by TwoStraws on 20/08/2016.
//  Copyright (c) 2016 TwoStraws. All rights reserved.
//

import UIKit

func documentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}

final class SelectionViewController: UITableViewController {
    
    private enum ViewMetrics {
        static let rowHeight: CGFloat = 90
    }
	
    private let defaults = UserDefaults.standard
    private let imageKey = "ImageKey"
    private let imageCellId = "ImageCell"
    
    private var imageFilenames = [String]()
    var isDirty = false

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        setupView()
    }
    
    private func setupView() {
        navigationItem.title = "Project 30"

        tableView.rowHeight = ViewMetrics.rowHeight
        tableView.separatorStyle = .none
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		if isDirty {
			// we've been marked as needing a counter reload, so reload the whole table
			tableView.reloadData()
		}
	}

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        imageFilenames.count * 10
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell(style: .default, reuseIdentifier: imageCellId)
		let imageFilename = imageFilenames[indexPath.row % imageFilenames.count]
        
		let imageFilePath = documentsDirectory().appendingPathComponent(imageFilename)
        guard let image = UIImage(contentsOfFile: imageFilePath.path) else { fatalError() }
        
        // give the images a nice shadow to make them look a bit more dramatic
        cell.imageView?.layer.shadowColor = UIColor.black.cgColor
        cell.imageView?.layer.shadowOpacity = 1
        cell.imageView?.layer.shadowRadius = 10
        cell.imageView?.layer.shadowOffset = CGSize.zero
        cell.imageView?.layer.shadowPath = UIBezierPath(ovalIn: CGRect(origin: .zero, size: CGSize(width: 90, height: 90))).cgPath
        
        cell.imageView?.image = image
		// each image stores how often it's been tapped
        cell.textLabel?.text = defaults.integer(forKey: imageFilename).description
		return cell
    }

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedImageFilename = imageFilenames[indexPath.row % imageFilenames.count]
		let detailVC = ImageViewController(owner: self, filename: selectedImageFilename)
		isDirty = false
		navigationController?.pushViewController(detailVC, animated: true)
	}
}

// MARK: - Data Management
extension SelectionViewController {
    fileprivate func saveData() {
        if let savedData = try? JSONEncoder().encode(imageFilenames) {
            defaults.set(savedData, forKey: imageKey)
        }
        else {
            print("Failed to save images.")
        }
    }
    
    fileprivate func loadData() {
        if let savedData = defaults.object(forKey: imageKey) as? Data {
            do {
                imageFilenames = try JSONDecoder().decode([String].self, from: savedData)
                DispatchQueue.main.async { [weak self] in self?.tableView.reloadData() }
            }
            catch {
                print("Failed to load saved images.")
            }
        }
        else {
            loadItems()
        }
    }
    
    private func loadItems() {
        guard let rootPath = Bundle.main.resourcePath, let tempItems = try? FileManager.default.contentsOfDirectory(atPath: rootPath) else { return }
        
        for item in tempItems where item.range(of: "Large") != nil {
            guard let original = UIImage(named: item) else { continue }
            
            let renderRectangle = CGRect(origin: .zero, size: CGSize(width: 90, height: 90))
            let renderer = UIGraphicsImageRenderer(size: renderRectangle.size)
            let rounded = renderer.image { ctx in
                ctx.cgContext.addEllipse(in: renderRectangle)
                ctx.cgContext.clip()
                original.draw(in: renderRectangle)
            }
            
            let imageFilename = UUID().uuidString
            let imageFilePath = documentsDirectory().appendingPathComponent(imageFilename)
            
            guard let pngData = rounded.pngData() else { return }
            try? pngData.write(to: imageFilePath)
            imageFilenames.append(imageFilename)
        }
        
        DispatchQueue.main.async { [weak self] in self?.tableView.reloadData() }
        saveData()
    }
}
