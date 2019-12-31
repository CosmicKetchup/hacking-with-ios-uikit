//
//  BrowserViewController.swift
//  p04.easy-browser
//
//  Created by Matt Brown on 10/6/19.
//  Copyright © 2019 Matt Brown. All rights reserved.
//

import UIKit
import WebKit

final class BrowserViewController: UIViewController, WKNavigationDelegate {
    
    private enum ViewMetrics {
        static let backgroundColor = UIColor.lightGray
    }
    
    private let targetWebsite: Website
    
    private let webView: WKWebView = {
        let view = WKWebView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.allowsBackForwardNavigationGestures = true
        return view
    }()
    
    private let progressView: UIProgressView = {
        let view = UIProgressView(progressViewStyle: .default)
        view.sizeToFit()
        return view
    }()
    
    init(url: Website) {
        self.targetWebsite = url
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
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        setupView()
        
        if let targetWebsite = targetWebsite.host {
            webView.load(URLRequest(url: targetWebsite))
        }
    }
    
    private func setupView() {
        view.backgroundColor = ViewMetrics.backgroundColor
        navigationItem.largeTitleDisplayMode = .never
        
        let progressBar = UIBarButtonItem(customView: progressView)
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let navBackButton = UIBarButtonItem(barButtonSystemItem: .rewind, target: webView, action: #selector(webView.goBack))
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        let navForwardButton = UIBarButtonItem(barButtonSystemItem: .fastForward, target: webView, action: #selector(webView.goForward))
        toolbarItems = [progressBar, spacer, navBackButton, refreshButton, navForwardButton]
        navigationController?.isToolbarHidden = false
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        navigationItem.title = webView.title
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let targetWebsite = navigationAction.request.url
        if let host = targetWebsite?.host {
            for website in Website.allCases where host.contains(website.domain) {
                    decisionHandler(.allow)
                    return
            }
        }
        
        decisionHandler(.cancel)
        
        let alert = UIAlertController(title: "Blocked Website", message: "This website is not whitelisted.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

