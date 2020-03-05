//
//  LocalNotiManager.swift
//  Personal Project
//
//  Created by Savannah Su on 2020/2/26.
//  Copyright © 2020 Savannah Su. All rights reserved.
//

import Foundation
import UserNotifications

class LocalNotiManager {
    
    static var shared = LocalNotiManager()
    
    private init() {}
    
    func setupNoti(notiDate: Double, type: String, meaasge: String) {
        
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        
        content.title = type
        
        content.subtitle = meaasge
        
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: notiDate,
            repeats: false
        )
        
        let request = UNNotificationRequest(
            identifier: "Local Noti",
            content: content,
            trigger: trigger
        )
        
        center.add(request) { (error) in
            if error != nil {
                print("Error = \(error?.localizedDescription ?? "error local notification")")
            }
        }
    }
}
