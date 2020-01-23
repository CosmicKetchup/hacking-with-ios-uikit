//
//  RootCollectionViewController.swift
//  p25.selfie-share
//
//  Created by Matt Brown on 1/22/20.
//  Copyright © 2020 Matt Brown. All rights reserved.
//

import UIKit
import MultipeerConnectivity

final class RootCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    private enum ViewMetrics {
        static let backgroundColor = UIColor.white
        static let imageCellSize = CGSize(width: 145, height: 145)
        static let interItemSpacing: CGFloat = 25.0
        static let sectionInsets = UIEdgeInsets(top: 10, left: 25, bottom: 10, right: 25)
    }
    
    private let mcServiceKey = "hws-project25"
    private var peerID = MCPeerID(displayName: UIDevice.current.name)
    private var mcSession: MCSession?
    private var mcAdvertiserAssistant: MCAdvertiserAssistant?
    private var userImages = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        mcSession?.delegate = self
    }

    private func setupView() {
        collectionView.backgroundColor = ViewMetrics.backgroundColor
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.reuseIdentifier)
        
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionInset = ViewMetrics.sectionInsets
        }
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Project 25"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showContentSelectionPrompt))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "ellipsis"), style: .plain, target: self, action: #selector(showConnectionOptionsPrompt))
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        userImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        ViewMetrics.imageCellSize
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.reuseIdentifier, for: indexPath) as? ImageCell else { fatalError() }
        let image = userImages[indexPath.item]
        cell.setImage(to: image)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        ViewMetrics.interItemSpacing
    }
}

extension RootCollectionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc fileprivate func showContentSelectionPrompt() {
        let alert = UIAlertController(title: nil, message: "Select content to share.", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Gallery Photo", style: .default, handler: importPhoto))
        alert.addAction(UIAlertAction(title: "Send Text Message", style: .default, handler: sendMessage))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.popoverPresentationController?.barButtonItem = navigationItem.leftBarButtonItem
        present(alert, animated: true)
    }
    
    private func importPhoto(action: UIAlertAction) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    private func sendMessage(action: UIAlertAction) {
        let alert = UIAlertController(title: "Send Message", message: "", preferredStyle: .alert)
        alert.addTextField()
        alert.addAction(UIAlertAction(title: "Submit", style: .default) { [weak self] _ in
            guard let textField = alert.textFields?.first, let userEntry = textField.text, let messageData = userEntry.data(using: .utf8) else { return }
            self?.send(messageData)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        dismiss(animated: true)
        userImages.insert(image, at: 0)
        collectionView.insertItems(at: [IndexPath(item: 0, section: 0)])
        
        guard let imageData = image.pngData() else { return }
        send(imageData)
    }
    
    @objc fileprivate func showConnectionOptionsPrompt() {
        let alert = UIAlertController(title: "Multipeer Options", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Host New Session", style: .default, handler: hostSession))
        alert.addAction(UIAlertAction(title: "Join Existing Session", style: .default, handler: joinSession))
        
        if let mcSession = mcSession, mcSession.connectedPeers.count > 0 {
            alert.addAction(UIAlertAction(title: "List Current Connections", style: .default, handler: showConnectedPeersPrompt))
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    private func hostSession(action: UIAlertAction) {
        guard let mcSession = mcSession else { return }
        mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: mcServiceKey, discoveryInfo: nil, session: mcSession)
        mcAdvertiserAssistant?.start()
    }
    
    private func joinSession(action: UIAlertAction) {
        guard let mcSession = mcSession else { return }
        let mcBrowser = MCBrowserViewController(serviceType: mcServiceKey, session: mcSession)
        mcBrowser.delegate = self
        present(mcBrowser, animated: true)
    }
    
    private func showConnectedPeersPrompt(action: UIAlertAction) {
        guard let mcSession = mcSession else { return }
        let connectedPeers = mcSession
            .connectedPeers
            .map { $0.displayName }
            .joined(separator: "\n")
        
        let alert = UIAlertController(title: "Connected Peers", message: connectedPeers, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func send(_ data: Data) {
        guard let mcSession = mcSession else { return }
        if mcSession.connectedPeers.count > 0 {
            do {
                try mcSession.send(data, toPeers: mcSession.connectedPeers, with: .reliable)
            }
            catch {
                let alert = UIAlertController(title: "Error Sending Data", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                present(alert, animated: true)
            }
        }
    }
}

// MARK: - Required MC Delegate Methods
extension RootCollectionViewController: MCBrowserViewControllerDelegate, MCSessionDelegate {
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        if let image = UIImage(data: data) {
            DispatchQueue.main.async { [weak self] in
                self?.userImages.insert(image, at: 0)
                self?.collectionView.insertItems(at: [IndexPath(item: 0, section: 0)])
            }
        }
        else if let message = String(data: data, encoding: .utf8) {
            DispatchQueue.main.async { [weak self] in
                let alert = UIAlertController(title: peerID.displayName, message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(alert, animated: true)
            }
        }
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            print("Connected: \(peerID.displayName)")
        case .connecting:
            print("Connecting: \(peerID.displayName)")
        case .notConnected:
            print("Not Connected: \(peerID.displayName)")
            
            DispatchQueue.main.async { [weak self] in
                let alert = UIAlertController(title: "Peer Disconnected", message: "\(peerID.displayName)\nhas disconnected.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(alert, animated: true)
            }
            
        @unknown default:
            print("Unknown Session State: \(peerID.displayName)")
        }
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) { }
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) { }
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) { }
}

