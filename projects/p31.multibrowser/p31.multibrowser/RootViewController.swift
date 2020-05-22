//
//  RootViewController.swift
//  p31.multibrowser
//
//  Created by Matt Brown on 5/21/20.
//  Copyright © 2020 Matt Brown. All rights reserved.
//

import UIKit
import WebKit

final class RootViewController: UIViewController {
    
    private enum ViewMetrics {
        static let margin: CGFloat = 5.0
        static let stackViewSpacing: CGFloat = 5.0
        
        static let borderColor = UIColor.blue.cgColor
        static let inactiveBorderWidth: CGFloat = 1.0
        static let activeBorderWidth: CGFloat = 3.0
    }
    
    private var activeWebView: WKWebView?
    
    private let addressBar: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.backgroundColor = .white
        return field
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        stack.spacing = ViewMetrics.stackViewSpacing
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addressBar.delegate = self
    }
    
    private func setupView() {
        navigationItem.title = "Project 31"
        
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addWebView))
        let delete = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteWebView))
        navigationItem.rightBarButtonItems = [delete, add]

        [addressBar, stackView].forEach { view.addSubview($0) }
        NSLayoutConstraint.activate([
            addressBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: ViewMetrics.margin),
            addressBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: ViewMetrics.margin),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: addressBar.trailingAnchor, constant: ViewMetrics.margin),
            
            stackView.topAnchor.constraint(equalTo: addressBar.bottomAnchor, constant: ViewMetrics.margin),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
        ])
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        stackView.axis = traitCollection.horizontalSizeClass == .compact ? .vertical : .horizontal
    }
}

extension RootViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let webView = activeWebView, let userEntry = addressBar.text, let address = URL(string: userEntry) {
            webView.load(URLRequest(url: address))
        }
        
        textField.resignFirstResponder()
        return true
    }
}

extension RootViewController: WKNavigationDelegate, UIGestureRecognizerDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if let webView = activeWebView {
            updateUI(for: webView)
        }
    }
    
    @objc private func addWebView() {
        guard let homepage = URL(string: "https://hackingwithswift.com") else { return }
        
        let webView = WKWebView()
        webView.navigationDelegate = self
        stackView.addArrangedSubview(webView)
        
        webView.load(URLRequest(url: homepage))
        webView.layer.borderColor = ViewMetrics.borderColor
        selectWebView(webView)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(webViewTapped))
        tapRecognizer.delegate = self
        webView.addGestureRecognizer(tapRecognizer)
    }
    
    @objc private func deleteWebView() {
        guard
            let webView = activeWebView,
            let index = stackView.arrangedSubviews.firstIndex(of: webView)
            else { return }
        
        webView.removeFromSuperview()
        
        if stackView.arrangedSubviews.isEmpty {
            navigationItem.title = "Project 31"
        }
        else {
            var currentIndex = Int(index)
            if currentIndex == stackView.arrangedSubviews.count {
                currentIndex = stackView.arrangedSubviews.count - 1
            }
            
            if let newTargetWebView = stackView.arrangedSubviews[currentIndex] as? WKWebView {
                selectWebView(newTargetWebView)
            }
        }
    }
    
    @objc private func webViewTapped(_ recognizer: UITapGestureRecognizer) {
        guard let selectedWebView = recognizer.view as? WKWebView else { return }
        selectWebView(selectedWebView)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
}

extension RootViewController {
    private func selectWebView(_ webView: WKWebView) {
        stackView.arrangedSubviews.forEach { $0.layer.borderWidth = ViewMetrics.inactiveBorderWidth }
        activeWebView = webView
        webView.layer.borderWidth = ViewMetrics.activeBorderWidth
        updateUI(for: webView)
    }
    
    private func updateUI(for webView: WKWebView) {
        navigationItem.title = webView.title
        addressBar.text = webView.url?.absoluteString ?? ""
    }
}
