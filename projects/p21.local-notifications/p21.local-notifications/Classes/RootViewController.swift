//
//  RootViewController.swift
//  p21.local-notifications
//
//  Created by Matt Brown on 1/18/20.
//  Copyright © 2020 Matt Brown. All rights reserved.
//

import UIKit
import UserNotifications

final class RootViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    private enum ViewMetrics {
        static let backgroundColor = UIColor.white
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = ViewMetrics.backgroundColor
        navigationItem.title = "Project 21"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleTapped))
    }
    
    private func registerCategories() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        let showMore = UNNotificationAction(identifier: "show", title: "Show me more", options: .foreground)
        let remindMe = UNNotificationAction(identifier: "remind", title: "Remind me later", options: .foreground)
        let category = UNNotificationCategory(identifier: "alarm", actions: [showMore, remindMe], intentIdentifiers: [])
        center.setNotificationCategories([category])
    }
    
    @objc private func registerLocal() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("User allowed notifications.")
            }
            else {
                print("That's not right.")
            }
        }
    }
    
    @objc private func scheduleTapped() {
        scheduleLocal(for: 5)
    }
    
    private func scheduleLocal(for interval: TimeInterval) {
        registerCategories()
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = "Late Wake-Up Call"
        content.body = "The early bird catches the worm, but the second mouse gets the cheese."
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = .default

//        var dateComponents = DateComponents()
//        dateComponents.hour = 10
//        dateComponents.minute = 30
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        if let customData = userInfo["customData"] as? String {
            print("Received custom data: \(customData)")
            
            var alertMessage: String? {
                switch response.actionIdentifier {
                case UNNotificationDefaultActionIdentifier:
                    return "User tapped on notification to open app."
                case "show":
                    return "User tapped 'View' then selected the 'Show me more' button."
                case "remind":
                    return "User wants to be reminded later."
                default:
                    return "No clue how you got here."
                }
            }
            
            let alert = UIAlertController(title: "Welcome Back", message: alertMessage, preferredStyle: .alert)
            
            var alertAction: UIAlertAction {
                switch response.actionIdentifier {
                case UNNotificationDefaultActionIdentifier:
                    return UIAlertAction(title: "Too easy.", style: .default)
                case "show":
                    return UIAlertAction(title: "Squeak, squeak!", style: .default)
                case "remind":
                    return UIAlertAction(title: "Alrighty then!", style: .default) { [weak self] _ in
                        self?.scheduleLocal(for: 86400)
                    }
                default:
                    return UIAlertAction(title: "OK", style: .default)
                }
            }
            
            alert.addAction(alertAction)
            present(alert, animated: true)
        }
        
        completionHandler()
    }
}

