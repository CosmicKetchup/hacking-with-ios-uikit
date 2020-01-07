//
//  RootViewController.swift
//  p13.instafilter
//
//  Created by Matt Brown on 1/5/20.
//  Copyright © 2020 Matt Brown. All rights reserved.
//

import UIKit
import CoreImage

class RootViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    fileprivate enum ViewMetrics {
        static let darkBackgroundColor = UIColor.darkGray
        static let lightBackgroundColor = UIColor.lightGray
        static let previewWindowMargins = NSDirectionalEdgeInsets(top: 10.0, leading: 10.0, bottom: 10.0, trailing: 10.0)
        
        static let intensityLabelTextColor = UIColor.black
        static let intensityLabelFont = UIFont.preferredFont(forTextStyle: .body)
        static let intensityStackSpacing = UIStackView.spacingUseSystem
        
        static let buttonInsets = UIEdgeInsets(top: 8.0, left: 16.0, bottom: 8.0, right: 16.0)
        static let buttonBackgroundColor = UIColor.systemBlue
        static let buttonTextColor = UIColor.white
        static let buttonFont = UIFont.preferredFont(forTextStyle: .body)
        static let buttonCornerRadius: CGFloat = 7.0
        static let buttonStackSpacing = UIStackView.spacingUseSystem
    }
    
    private var currentImage: UIImage!
    private var context: CIContext!
    private var currentFilter: CIFilter! {
        didSet {
            guard let currentFilterName = CIFilterType(named: currentFilter.name) else { return }
            changeFilterButton.setTitle(currentFilterName.rawValue, for: .normal)
        }
    }
    
    private let previewImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let previewWindow: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.directionalLayoutMargins = ViewMetrics.previewWindowMargins
        view.backgroundColor = ViewMetrics.darkBackgroundColor
        view.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return view
    }()
    
    private let intensitySlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0.01
        slider.addTarget(self, action: #selector(intensityChanged(_:)), for: .valueChanged)
        return slider
    }()
    
    private let intensityLabel: UILabel = {
        let label = UILabel()
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.numberOfLines = 1
        
        label.font = ViewMetrics.intensityLabelFont
        label.adjustsFontForContentSizeCategory = true
        label.text = "Intensity"
        label.textColor = ViewMetrics.intensityLabelTextColor
        label.textAlignment = .right

        return label
    }()
    
    private lazy var intensityStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [intensityLabel, intensitySlider])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = ViewMetrics.intensityStackSpacing
        return stack
    }()

    private let changeFilterButton: UIButton = {
        let button = UIButton(text: "Change Filter")
        button.addTarget(self, action: #selector(changeFilter(_:)), for: .touchUpInside)
        return button
    }()

    private let saveButton: UIButton = {
        let button = UIButton(text: "Save")
        button.addTarget(self, action: #selector(savePhoto(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var buttonStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [changeFilterButton, saveButton])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        stack.spacing = ViewMetrics.buttonStackSpacing
        return stack
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        context = CIContext()
        currentFilter = CIFilterType.sepiaTone.filter
    }
    
    private func setupView() {
        view.backgroundColor = ViewMetrics.lightBackgroundColor
        navigationItem.title = "Project 13"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPhoto))
        
        [previewWindow, intensityStack, buttonStack].forEach { view.addSubview($0) }
        [previewImageView].forEach { previewWindow.addSubview($0) }
        
        NSLayoutConstraint.activate([
            previewWindow.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            previewWindow.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            previewWindow.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            previewImageView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            previewImageView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            previewImageView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            previewImageView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            intensityStack.topAnchor.constraint(equalToSystemSpacingBelow: previewWindow.bottomAnchor, multiplier: 1.0),
            intensityStack.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            intensityStack.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            buttonStack.topAnchor.constraint(equalToSystemSpacingBelow: intensityStack.bottomAnchor, multiplier: 4.0),
            buttonStack.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            buttonStack.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            buttonStack.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
        ])
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else { return }
        dismiss(animated: true)
        currentFilter.setValue(CIImage(image: selectedImage), forKey: kCIInputImageKey)
        currentImage = selectedImage
        applyProcessing()
    }
    
    @objc fileprivate func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer?) {
        if let error = error {
            let alert = UIAlertController(title: "Save Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
        else {
            let alert = UIAlertController(title: "Image Saved", message: "Your filter has been applied and the resulting image has been saved.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
}

extension RootViewController {
    @objc fileprivate func intensityChanged(_ sender: Any) {
        applyProcessing()
    }
    
    private func applyProcessing() {
        guard currentImage != nil else { return }
        let inputKeys = currentFilter.inputKeys
        
        // checks each of four keys and modifies the image appropriately
        if inputKeys.contains(kCIInputIntensityKey) { currentFilter.setValue(intensitySlider.value, forKey: kCIInputIntensityKey) }
        if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(intensitySlider.value * 200, forKey: kCIInputRadiusKey) }
        if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(intensitySlider.value * 10, forKey: kCIInputScaleKey) }
        if inputKeys.contains(kCIInputCenterKey) { currentFilter.setValue(CIVector(x: currentImage.size.width / 2, y: currentImage.size.height / 2), forKey: kCIInputCenterKey) }
        
        if let targetPhoto = currentFilter.outputImage, let cgImg = context.createCGImage(targetPhoto, from: targetPhoto.extent) {
            previewImageView.image = UIImage(cgImage: cgImg)
        }
    }
    
    @objc public func changeFilter(_ sender: Any) {
        let alert = UIAlertController(title: "Choose Filter", message: nil, preferredStyle: .actionSheet)
        CIFilterType.allCases.forEach { alert.addAction(filterAction(type: $0)) }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    private func filterAction(type: CIFilterType) -> UIAlertAction {
        UIAlertAction(title: type.rawValue, style: .default, handler: setFilter)
    }
    
    private func setFilter(_ action: UIAlertAction) {
        guard let actionTitle = action.title, let filterType = CIFilterType(rawValue: actionTitle)?.filter else { return }
        currentFilter = filterType
        
        if let currentImage = self.currentImage, let baseImage = CIImage(image: currentImage) {
            currentFilter.setValue(baseImage, forKey: kCIInputImageKey)
            applyProcessing()
        }
    }
    
    @objc public func savePhoto(_ sender: Any) {
        if let filteredPhoto = previewImageView.image {
            UIImageWriteToSavedPhotosAlbum(filteredPhoto, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
        else {
            let alert = UIAlertController(title: "Image Error", message: "Please choose an image from photo library before attempting to save.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
    
    @objc fileprivate func importPhoto() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
}

private extension UIButton {
    convenience init(text: String) {
        self.init(type: .custom)
        translatesAutoresizingMaskIntoConstraints = false
        contentEdgeInsets = RootViewController.ViewMetrics.buttonInsets
        
        setTitle(text, for: .normal)
        setTitleColor(RootViewController.ViewMetrics.buttonTextColor, for: .normal)
        backgroundColor = RootViewController.ViewMetrics.buttonBackgroundColor
        
        layer.cornerRadius = RootViewController.ViewMetrics.buttonCornerRadius
    }
}
