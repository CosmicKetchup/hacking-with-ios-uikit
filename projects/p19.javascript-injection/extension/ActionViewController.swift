//
//  ActionViewController.swift
//  extension
//
//  Created by Matt Brown on 1/16/20.
//  Copyright © 2020 Matt Brown. All rights reserved.
//

import UIKit
import MobileCoreServices

final class ActionViewController: UIViewController {

    var pageTitle = ""
    var pageURL = ""
    
    let defaults = UserDefaults.standard
    let savedScriptsKey = "savedScripts"
    var savedUserScripts = [[String: String]]()
    
    private let textView: UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.autocapitalizationType = .none
        view.autocorrectionType = .no
        view.smartDashesType = .no
        view.smartInsertDeleteType = .no
        view.smartQuotesType = .no
        view.spellCheckingType = .no
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        loadUserScripts()
        
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    private func setupView() {
        navigationItem.title = "Enter JavaScript"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(selectTapped))
        
        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem, let itemProvider = inputItem.attachments?.first {
            itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) { [weak self] (dict, error) in
                guard let itemDictionary = dict as? NSDictionary else { return }
                guard let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else { return }
                
                self?.pageTitle = javaScriptValues["title"] as? String ?? ""
                self?.pageURL = javaScriptValues["URL"] as? String ?? ""
                
                guard let pageURL = self?.pageURL, let host = URL(string: pageURL) else { return }
                self?.loadPreviousScript(for: host)
            }
        }
        
        [textView].forEach { view.addSubview($0) }
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            textView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            textView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            textView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
        ])
    }
    
    @objc private func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            textView.contentSize = .zero
        }
        else {
            textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
        }
        
        textView.scrollIndicatorInsets = textView.contentInset
        let selectedRange = textView.selectedRange
        textView.scrollRangeToVisible(selectedRange)
    }
    
    @objc private func selectTapped() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Page Title", style: .default) { [weak self] _ in
            self?.textView.text = "alert(document.title);"
            })
        
        alert.addAction(UIAlertAction(title: "Selected Word Count", style: .default) { [weak self] _ in
            self?.textView.text = """
            var t;
            
            if (window.getSelection) t = window.getSelection();
            else if (document.selection) t = document.selection.createRange();
            if (t.text != undefined) t = t.text;
            
            if (!t || t == "") {
                a = document.getElementsByTagName("textarea");
                for(i=0; i<a.length; i++) {
                    if(a[i].selectionStart != undefined && a[i].selectionStart != a[i].selectionEnd) {
                        t = a[i].value.substring(a[i].selectionStart, a[i].selectionEnd);
                        break;
                    }
                }
            }
            
            if(!t || t == "") alert("Please select some text");
            else alert("Word count: " + t.toString().match(/(\\S+)/g).length);
            """
        })
        
        savedUserScripts.forEach { [weak self] dict in
            dict.forEach { (name, script) in
                alert.addAction(UIAlertAction(title: name, style: .default) { _ in
                    self?.textView.text = script
                })
            }
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.popoverPresentationController?.barButtonItem = navigationItem.leftBarButtonItem
        present(alert, animated: true)
    }
    
    @objc private func doneTapped() {
        let alert = UIAlertController(title: "Save Script", message: "Please enter a name for your script\nor tap the SKIP button.", preferredStyle: .alert)
        alert.addTextField()
        
        alert.addAction(UIAlertAction(title: "Skip", style: .default, handler: submitScript))
        alert.addAction(UIAlertAction(title: "Submit", style: .default) { [weak self] _ in
            guard let alertTextField = alert.textFields?.first, let scriptName = alertTextField.text, let userScript = self?.textView.text else { return }
            self?.saveUserScript(as: scriptName, script: userScript)
            self?.submitScript()
        })
        
        present(alert, animated: true)
    }
    
    private func submitScript(_ action: UIAlertAction? = nil) {
        guard let script = textView.text else { return }
        let item = NSExtensionItem()
        let argument: NSDictionary = ["customJavaScript": script as Any]
        let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
        let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
        item.attachments = [customJavaScript]
        
        extensionContext?.completeRequest(returningItems: [item]) { [weak self] _ in
            guard let pageURL = self?.pageURL, let website = URL(string: pageURL)?.host else { return }
            self?.savePreviousScript(for: website)
        }
    }
}

// MARK: - Data Management
extension ActionViewController {
    private func saveUserScript(as name: String, script: String) {
        let userScript = [name: script]
        savedUserScripts.append(userScript)
        
        if let savedScriptData = try? JSONEncoder().encode(savedUserScripts) {
            defaults.set(savedScriptData, forKey: savedScriptsKey)
        }
    }
    
    private func loadUserScripts() {
        if let scriptData = defaults.object(forKey: savedScriptsKey) as? Data {
            do {
                savedUserScripts = try JSONDecoder().decode([[String: String]].self, from: scriptData)
            }
            catch {
                print("Failed to load saved scripts.")
            }
        }
    }
    
    private func savePreviousScript(for host: String) {
        if let userEntry = textView.text, let savedScript = try? JSONEncoder().encode(userEntry) {
            defaults.set(savedScript, forKey: host)
        }
        else {
            print("Failed to save people.")
        }
    }
    
    private func loadPreviousScript(for host: URL) {
        if let website = host.host, let savedData = defaults.object(forKey: website) as? Data {
            do {
                let previousScript = try JSONDecoder().decode(String.self, from: savedData)
                
                DispatchQueue.main.async { [weak self] in
                    self?.textView.text = previousScript
                }
            }
            catch {
                print("Failed to load previous script for website.")
            }
        }
    }
}
