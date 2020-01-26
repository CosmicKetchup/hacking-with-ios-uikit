//
//  RootViewController.swift
//  p28.secret-swift
//
//  Created by Matt Brown on 1/25/20.
//  Copyright © 2020 Matt Brown. All rights reserved.
//

import UIKit
import LocalAuthentication

final class RootViewController: UIViewController {
    
    private enum ViewMetrics {
        static let backgroundColor = UIColor.white
        
        static let buttonInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        static let buttonFont = UIFont.boldSystemFont(ofSize: 44.0)
        static let buttonColor = UIColor.systemBlue
        static let buttonTextColor = UIColor.white
        static let buttonCornerRadius: CGFloat = 7.0
        static let buttonBorderWidth: CGFloat = 2.0
        static let buttonBorderColor = UIColor.darkGray.cgColor
        
        static let textViewFont = UIFont.preferredFont(forTextStyle: .body)
    }
    
    private let unlockCodeKey = "UnlockCode"
    private var unlockCode: String!
    private let secretTextKey = "SecretMessage"
    private var isAuthenticated = false {
        didSet {
            navigationItem.leftBarButtonItem = isAuthenticated ? UIBarButtonItem(title: "Set Password", style: .plain, target: self, action: #selector(setPassword)) : nil
            navigationItem.rightBarButtonItem = isAuthenticated ? UIBarButtonItem(title: "Lock", style: .plain, target: self, action: #selector(lockTapped)) : nil
        }
    }
    
    private let authenticateButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentEdgeInsets = ViewMetrics.buttonInsets
        
        button.titleLabel?.font = ViewMetrics.buttonFont
        button.setTitle("Authenticate", for: .normal)
        button.setTitleColor(ViewMetrics.buttonTextColor, for: .normal)
        button.backgroundColor = ViewMetrics.buttonColor
        
        button.layer.cornerRadius = ViewMetrics.buttonCornerRadius
        button.layer.borderWidth = ViewMetrics.buttonBorderWidth
        button.layer.borderColor = ViewMetrics.buttonBorderColor
        
        button.addTarget(self, action: #selector(authenticationTapped), for: .touchUpInside)
        return button
    }()
    
    private let secretTextView: UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.autocapitalizationType = .none
        view.autocorrectionType = .no
        view.smartDashesType = .no
        view.smartQuotesType = .no
        view.smartInsertDeleteType = .no
        
        view.font = ViewMetrics.textViewFont
        view.textAlignment = .left
        view.isHidden = true
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(saveSecretMessage), name: UIApplication.willResignActiveNotification, object: nil)
        
        unlockCode = KeychainWrapper.standard.string(forKey: unlockCodeKey) ?? nil
        setupView()
    }
    
    private func setupView() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = "Project 28"
        
        view.backgroundColor = ViewMetrics.backgroundColor
        
        [authenticateButton, secretTextView].forEach { view.addSubview($0) }
        NSLayoutConstraint.activate([
            secretTextView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            secretTextView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            secretTextView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            secretTextView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            authenticateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            authenticateButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}

extension RootViewController {
    @objc fileprivate func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            secretTextView.contentInset = .zero
        }
        else {
            secretTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: (keyboardViewEndFrame.height - view.safeAreaInsets.bottom), right: 0)
            secretTextView.scrollIndicatorInsets = secretTextView.contentInset
            let selectedRange = secretTextView.selectedRange
            secretTextView.scrollRangeToVisible(selectedRange)
        }
    }
    
    @objc fileprivate func authenticationTapped(_ sender: Any? = nil) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Unlock Secret Message"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] (success, authError) in
                DispatchQueue.main.async {
                    if success {
                        self?.unlockSecretMessage()
                    }
                    else {
                        let alert = UIAlertController(title: "Authentication Error", message: "Failed to verify user.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        if self?.unlockCode != nil { alert.addAction(UIAlertAction(title: "Use Password Instead", style: .default, handler: self?.promptForPassword)) }
                        self?.present(alert, animated: true)
                    }
                }
            }
        }
        else {
            let alert = UIAlertController(title: "Authentication Unavailable", message: "Biometric authentication is either\nnot configured or unavailable for this device.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
    
    @objc fileprivate func unlockSecretMessage() {
        secretTextView.isHidden = false
        isAuthenticated = true
        guard isAuthenticated, let secretText = KeychainWrapper.standard.string(forKey: secretTextKey) else { return }
        navigationItem.title = "Secret Revealed"
        secretTextView.text = secretText
    }
    
    @objc fileprivate func saveSecretMessage() {
        guard !secretTextView.isHidden else { return }
        KeychainWrapper.standard.set(secretTextView.text, forKey: secretTextKey)
        secretTextView.resignFirstResponder()
        secretTextView.isHidden = true
    }
    
    @objc fileprivate func lockTapped() {
        isAuthenticated = false
        saveSecretMessage()
    }
    
    private func promptForPassword(_ action: UIAlertAction) {
        let alert = UIAlertController(title: "Enter Password", message: nil, preferredStyle: .alert)
        alert.addTextField()
        alert.addAction(UIAlertAction(title: "Submit", style: .default) { [weak self] _ in
            guard let textField = alert.textFields?.first, let userEntry = textField.text, let unlockCode = self?.unlockCode else { return }
            if userEntry == unlockCode {
                self?.isAuthenticated = true
                self?.unlockSecretMessage()
            }
            else {
                let alert = UIAlertController(title: "Incorrect Password", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: self?.promptForPassword))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                self?.present(alert, animated: true)
            }
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    @objc fileprivate func setPassword() {
        let alert = UIAlertController(title: "Set Password", message: nil, preferredStyle: .alert)
        alert.addTextField()
        alert.addAction(UIAlertAction(title: "Submit", style: .default) { [weak self] _ in
            guard let textField = alert.textFields?.first, let userEntry = textField.text, let unlockCodeKey = self?.unlockCodeKey else { return }
            self?.unlockCode = userEntry
            KeychainWrapper.standard.set(userEntry, forKey: unlockCodeKey)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
}
