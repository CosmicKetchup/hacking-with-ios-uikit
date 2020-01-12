//
//  BrowserViewController.swift
//  p16.capital-cities
//
//  Created by Matt Brown on 1/12/20.
//  Copyright © 2020 Matt Brown. All rights reserved.
//

import UIKit
import WebKit

final class BrowserViewController: UIViewController, WKNavigationDelegate {
    
    private let webView: WKWebView = {
        let view = WKWebView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.allowsBackForwardNavigationGestures = true
        return view
    }()
    
    private let targetCity: CapitalCity
    
    init(for city: CapitalCity) {
        self.targetCity = city
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        webView.load(URLRequest(url: targetCity.wiki))
    }
    
    private func setupView() {
        navigationItem.title = targetCity.rawValue
    }
}
