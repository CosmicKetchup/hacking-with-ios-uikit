//
//  RecordWhistleViewController.swift
//  p33.whats-that-whistle
//
//  Created by Matt Brown on 12/25/20.
//

import AVFoundation
import UIKit

final class RecordWhistleViewController: UIViewController {
    fileprivate enum ViewMetrics {
        static let standardBackgroundColor = UIColor.systemGray
        static let recordingBackgroundColor = UIColor.systemRed
        
        
        static let stackItemSpacing: CGFloat = 30.0
        
        static let buttonInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        static let buttonFont = UIFont.preferredFont(forTextStyle: .title1)
        static let buttonCornerRadius: CGFloat = 9.0
        static let buttonBorderWidth: CGFloat = 1.0
        static let buttonBorderColor = UIColor.white.cgColor
        
        static let recordButtonBackgroundColor = UIColor.systemRed
        static let recordButtonTextColor = UIColor.white
        static let recordButtonRecordingBackgroundColor = UIColor.white
        static let recordButtonRecordingTextColor = UIColor.systemRed
        
        static let playbackButtonBackgroundColor = UIColor.systemGreen
        
        static let labelFont = UIFont.preferredFont(forTextStyle: .headline)
    }
    
    fileprivate enum AnimationMetrics {
        static let playbackButtonAnimationDuration: TimeInterval = 0.35
    }
    
    private var recordingSession: AVAudioSession!
    private var whistleRecorder: AVAudioRecorder!
    private var whistlePlayer: AVAudioPlayer!
    
    private let recordButton: UIButton = {
        let button = UIButton(title: "Tap to Record", bgColor: ViewMetrics.recordButtonBackgroundColor)
        button.addTarget(self, action: #selector(recordButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let playbackButton: UIButton = {
        let button = UIButton(title: "Play Recording", bgColor: ViewMetrics.playbackButtonBackgroundColor)
        button.addTarget(self, action: #selector(playbackButtonTapped), for: .touchUpInside)
        button.isHidden = true
        button.alpha = 0
        return button
    }()
    
    private let failLabel: UILabel = {
        let label = UILabel()
        label.text = "Recording Failure: Please ensure the app has permission to use your microphone."
        label.font = ViewMetrics.labelFont
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var contentStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.alignment = .center
        stack.spacing = ViewMetrics.stackItemSpacing
        return stack
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { allowed in
                DispatchQueue.main.async { [weak self] in
                    allowed ? self?.loadRecordingUI() : self?.loadFailUI()
                }
            }
        }
        catch {
            loadFailUI()
        }
    }
    
    private func setupView() {
        navigationItem.title = "Record Your Whistle"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Record", style: .plain, target: nil, action: nil)
        
        view.backgroundColor = ViewMetrics.standardBackgroundColor
        
        [contentStack].forEach { view.addSubview($0) }
        NSLayoutConstraint.activate([
            contentStack.centerYAnchor.constraint(equalTo: view.layoutMarginsGuide.centerYAnchor),
            contentStack.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
        ])
    }
    
    private func loadRecordingUI() {
        [recordButton, playbackButton].forEach { contentStack.addArrangedSubview($0) }
    }
    
    private func loadFailUI() {
        contentStack.addArrangedSubview(failLabel)
    }
    
    private func startRecording() {
        navigationItem.rightBarButtonItem = nil
        view.backgroundColor = ViewMetrics.recordingBackgroundColor
        
        recordButton.setTitle("Tap to Stop", for: .normal)
        recordButton.backgroundColor = ViewMetrics.recordButtonRecordingBackgroundColor
        recordButton.setTitleColor(ViewMetrics.recordButtonRecordingTextColor, for: .normal)
        
        let audioURL = RecordWhistleViewController.whistleURL()
        print(audioURL.absoluteURL)
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue,
        ]
        
        do {
            whistleRecorder = try AVAudioRecorder(url: audioURL, settings: settings)
            whistleRecorder.delegate = self
            whistleRecorder.record()
        }
        catch {
            finishRecording(successful: false)
        }
    }
    
    private func finishRecording(successful: Bool) {
        view.backgroundColor = ViewMetrics.standardBackgroundColor
        
        whistleRecorder.stop()
        whistleRecorder = nil
        
        if successful {
            if playbackButton.isHidden {
                UIView.animate(withDuration: AnimationMetrics.playbackButtonAnimationDuration) { [weak self] in
                    self?.playbackButton.isHidden = false
                    self?.playbackButton.alpha = 1.0
                }
            }
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextButtonTapped))
            
            recordButton.setTitle("Tap to Re-record", for: .normal)
            recordButton.setTitleColor(ViewMetrics.recordButtonTextColor, for: .normal)
            recordButton.backgroundColor = ViewMetrics.recordButtonBackgroundColor
        }
        else {
            recordButton.setTitle("Tap to Record", for: .normal)
            
            let alert = UIAlertController(title: "Recording Failed", message: "There was a problem recording your whistle. Please try again.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
}

extension RecordWhistleViewController {
    class func whistleURL() -> URL {
        documentsDirectory().appendingPathComponent("whistle.m4a")
    }
}

extension RecordWhistleViewController {
    @objc private func recordButtonTapped() {
        if whistleRecorder != nil {
            finishRecording(successful: true)
        }
        else {
            startRecording()
            if !playbackButton.isHidden {
                UIView.animate(withDuration: AnimationMetrics.playbackButtonAnimationDuration) { [weak self] in
                    self?.playbackButton.isHidden = true
                    self?.playbackButton.alpha = 0
                }
            }
        }
    }
    
    @objc private func playbackButtonTapped() {
        let audioURL = RecordWhistleViewController.whistleURL()
        
        do {
            whistlePlayer = try AVAudioPlayer(contentsOf: audioURL)
            whistlePlayer.play()
        }
        catch {
            let alert = UIAlertController(title: "Playback Failure", message: "There was a problem playing your recording.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
    
    @objc private func nextButtonTapped() {
        let selectGenreVC = SelectGenreTableViewController()
        navigationController?.pushViewController(selectGenreVC, animated: true)
    }
}

extension RecordWhistleViewController: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(successful: false)
        }
    }
}

private extension UIButton {
    convenience init(title: String, bgColor: UIColor) {
        self.init()
        backgroundColor = bgColor
        contentEdgeInsets = RecordWhistleViewController.ViewMetrics.buttonInsets
        layer.cornerRadius = RecordWhistleViewController.ViewMetrics.buttonCornerRadius
        layer.borderWidth = RecordWhistleViewController.ViewMetrics.buttonBorderWidth
        layer.borderColor = RecordWhistleViewController.ViewMetrics.buttonBorderColor
        
        setTitle(title, for: .normal)
        titleLabel?.font = RecordWhistleViewController.ViewMetrics.buttonFont
        titleLabel?.adjustsFontForContentSizeCategory = true
    }
}
