//
//  GameViewController.swift
//  p29.exploding-monkeys
//
//  Created by Matt Brown on 1/25/20.
//  Copyright © 2020 Matt Brown. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    var currentGame: GameScene!
    private var activePlayer: Int! {
        didSet {
            activePlayerLabel.text = (activePlayer == 1) ? "<<< PLAYER ONE" : "PLAYER TWO >>>"
        }
    }
    
    private let angleSlider: UISlider = {
        let slider = UISlider(current: 45, max: 90)
        slider.addTarget(self, action: #selector(angleChanged), for: .valueChanged)
        return slider
    }()
    private let angleLabel = UILabel(text: "ANGLE")
    private lazy var angleStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [angleSlider, angleLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = UIStackView.spacingUseSystem
        return stack
    }()
    
    private let velocitySlider: UISlider = {
        let slider = UISlider(current: 125, max: 250)
        slider.addTarget(self, action: #selector(velocityChanged), for: .valueChanged)
        return slider
    }()
    private let velocityLabel = UILabel(text: "VELOCITY")
    private lazy var velocityStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [velocitySlider, velocityLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = UIStackView.spacingUseSystem
        return stack
    }()
    
    private let activePlayerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = .boldSystemFont(ofSize: 22.0)
        label.textAlignment = .center
        label.textColor = .white
        
        return label
    }()
    
    private let launchButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        button.titleLabel?.font = .boldSystemFont(ofSize: 22.0)
        button.setTitle("LAUNCH", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.red
        
        button.layer.cornerRadius = 7.0
        button.layer.borderWidth = 2.0
        button.layer.borderColor = UIColor.lightGray.cgColor
        
        button.addTarget(self, action: #selector(launch), for: .touchUpInside)
        return button
    }()
    
    private var p1Score = 0
    private var p2Score = 0
    private lazy var scoreLabel: UIButton = {
        let label = UIButton()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        label.isUserInteractionEnabled = false
        
        label.titleLabel?.font = .boldSystemFont(ofSize: 34.0)
        label.setTitle("\(p1Score) : \(p2Score)", for: .normal)
        label.setTitleColor(.white, for: .normal)
        label.backgroundColor = UIColor(white: 0, alpha: 0.65)
        return label
    }()
    
    private let windLabel: UIButton = {
        let label = UIButton()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        label.isUserInteractionEnabled = false
        
        label.titleLabel?.font = .boldSystemFont(ofSize: 34.0)
        label.setTitle("WIND: 0", for: .normal)
        label.setTitleColor(.white, for: .normal)
        label.backgroundColor = UIColor(white: 0, alpha: 0.65)
        return label
    }()
    
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .fill
                
                // Present the scene
                view.presentScene(scene)
                currentGame = scene as? GameScene
                currentGame.parentViewController = self
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = false
            view.showsNodeCount = false
        }
        
        setupView()
        angleChanged(angleSlider)
        velocityChanged(velocitySlider)
        activatePlayer(1)
    }
    
    private func setupView() {
        [angleStack, velocityStack, launchButton, activePlayerLabel, scoreLabel, windLabel].forEach { view.addSubview($0) }
        NSLayoutConstraint.activate([
            angleStack.topAnchor.constraint(equalToSystemSpacingBelow: view.layoutMarginsGuide.topAnchor, multiplier: 1.0),
            angleStack.leadingAnchor.constraint(greaterThanOrEqualToSystemSpacingAfter: view.layoutMarginsGuide.leadingAnchor, multiplier: 1.0),
            angleStack.widthAnchor.constraint(equalToConstant: 300),
            
            launchButton.leadingAnchor.constraint(equalToSystemSpacingAfter: angleStack.trailingAnchor, multiplier: 5.0),
            launchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            launchButton.centerYAnchor.constraint(equalTo: angleStack.centerYAnchor),
            
            velocityStack.leadingAnchor.constraint(equalToSystemSpacingAfter: launchButton.trailingAnchor, multiplier: 5.0),
            velocityStack.topAnchor.constraint(equalToSystemSpacingBelow: view.layoutMarginsGuide.topAnchor, multiplier: 1.0),
            view.layoutMarginsGuide.trailingAnchor.constraint(greaterThanOrEqualToSystemSpacingAfter: velocityStack.trailingAnchor, multiplier: 1.0),
            velocityStack.widthAnchor.constraint(equalTo: angleStack.widthAnchor),
            
            activePlayerLabel.topAnchor.constraint(equalToSystemSpacingBelow: launchButton.bottomAnchor, multiplier: 3.0),
            activePlayerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            windLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            scoreLabel.topAnchor.constraint(equalToSystemSpacingBelow: windLabel.bottomAnchor, multiplier: 3.0),
            scoreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            view.layoutMarginsGuide.bottomAnchor.constraint(equalToSystemSpacingBelow: scoreLabel.bottomAnchor, multiplier: 3.0),
        ])
    }
}

extension GameViewController {
    @objc fileprivate func angleChanged(_ sender: Any) {
        angleLabel.text = "ANGLE: \(Int(angleSlider.value))°"
    }
    
    @objc fileprivate func velocityChanged(_ sender: Any) {
        velocityLabel.text = "VELOCITY: \(Int(velocitySlider.value))"
    }
    
    @objc fileprivate func launch(_ sender: Any) {
        [angleStack, velocityStack, launchButton, activePlayerLabel].forEach { $0.isHidden = true }
        let selectedAngle = Int(angleSlider.value)
        let selectedVelocity = Int(velocitySlider.value)
        currentGame.launch(angle: selectedAngle, velocity: selectedVelocity)
    }
    
    func activatePlayer(_ number: Int) {
        activePlayer = number
        [angleStack, velocityStack, launchButton, activePlayerLabel].forEach { $0.isHidden = false }
        currentGame.currentPlayer = number
    }
    
    func gameWon(by player: GameScene.Player) {
        if player == .player1 {
            p1Score += 1
        }
        else {
            p2Score += 1
        }
        
        scoreLabel.setTitle("\(p1Score) : \(p2Score)", for: .normal)
    }
    
    func updateWindDisplay(to speed: Int) {
        windLabel.setTitle("WIND: \(speed)", for: .normal)
        currentGame.windSpeedReported = true
    }
}

private extension UISlider {
    convenience init(current: Float, max: Float) {
        self.init()
        self.maximumValue = max
        self.value = current
    }
}

private extension UILabel {
    convenience init(text: String) {
        self.init()
        
        self.font = .boldSystemFont(ofSize: 22.0)
        self.text = "\(text): 0"
        textColor = .white
        textAlignment = .center
    }
}
