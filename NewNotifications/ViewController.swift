//
//  ViewController.swift
//  NewNotifications
//
//  Created by Frank on 2017/1/31.
//  Copyright © 2017年 Frank. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // 1. Request permission
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Notification access granted")
            } else {
                print(error?.localizedDescription as Any)
            }
        }
    }

    @IBAction func notifyBtnTapped(_ sender: UIButton) {
        scheduleNotification(inSecond: 5) { (success) in
            if success {
                print("Successfully scheduled notification")
            } else {
                print("Error!")
            }
        }
    }

    func scheduleNotification(inSecond: TimeInterval, completion: @escaping (_ Success: Bool) -> ()) {
        // Add an attachment
        let myImg = "rick_grimes"
        guard let imgUrl = Bundle.main.url(forResource: myImg, withExtension: "gif") else {
            completion(false)
            return
        }
        
        var attachment: UNNotificationAttachment
        
        attachment = try! UNNotificationAttachment(identifier: "myNoification", url: imgUrl, options: .none)
        
        let notif = UNMutableNotificationContent()
        
        // Only for extension:
        notif.categoryIdentifier = "myNotificationCategory"

        notif.title = "New Notification"
        notif.subtitle = "These are great!"
        notif.body = "The new notification options in iOS 10 are what I've always dreams of!"
        notif.attachments = [attachment]
        
        
        let notifTrigger = UNTimeIntervalNotificationTrigger(timeInterval: inSecond, repeats: false)
        let request = UNNotificationRequest(identifier: "myNotification", content: notif, trigger: notifTrigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
            } else {
                completion(true)
            }
        }
    }
}

