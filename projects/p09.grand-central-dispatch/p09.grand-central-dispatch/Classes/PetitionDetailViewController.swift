//
//  PetitionDetailViewController.swift
//  p09.grand-central-dispatch
//
//  Created by Matt Brown on 10/10/19.
//  Copyright © 2019 Matt Brown. All rights reserved.
//

import UIKit
import WebKit

class PetitionDetailViewController: UIViewController {
    
    private var webView: WKWebView!
    private var selectedPetition: Petition
    
    init(show petition: Petition) {
        self.selectedPetition = petition
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        formatHtmlResponse()
    }
    
    private func setupView() {
        navigationItem.title = selectedPetition.title
        navigationItem.largeTitleDisplayMode = .never
    }
    
    private func formatHtmlResponse() {
        let html = """
        <html>
            <head>
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <style> body { font-size: 150%; } </style>
            </head>
            <body>
            \(selectedPetition.body)
            </body>
        </html>
        """

        webView.loadHTMLString(html, baseURL: nil)
    }
}
