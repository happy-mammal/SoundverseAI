//
//  NotificationServic.swift
//  SoundverseAI
//
//  Created by Yash Lalit on 27/02/25.
//

import Foundation
import UserNotifications
import UIKit


enum NotificationServiceError: Error {
    case notAuthorized, unknown(String)
}

class NotificationService: NSObject, ObservableObject {
    
    let dummyNotifications = [
       NotificationItem(icon: "waveform.path", text: "🔊 Soundwave analysis complete—try now!"),
       NotificationItem(icon: "music.mic", text: "🎤 Your favorite artist released a new song!"),
       NotificationItem(icon: "megaphone.fill", text: "🚀 Soundverse AI update is live!"),
       NotificationItem(icon: "person.2.fill", text: "Your friend joined Soundverse AI! 👥"),
       NotificationItem(icon: "star.fill", text: "Exclusive playlist curated for you! 🌟"),
    ]
 
    @Published var unReaded:Bool = false
    
    @Published var showNotificationAlert:Bool = false
    
    @Published var notifications:[NotificationItem] = []
    
    private var authorizationStatus:(isSuccess:Bool, error: Error?) = (false,nil)
    
    private let notificationCenter = UNUserNotificationCenter.current()
    
    static let shared = NotificationService()
    
    override private init() {
        super.init()
        notificationCenter.delegate = self
    }
    
    func requestPermission() {
        notificationCenter.requestAuthorization(options: [.alert,.sound]) { isSuccess, error in
            
            if let error {
                self.authorizationStatus = (false,error)
                return
            }
            
            self.authorizationStatus = (isSuccess,nil)
        }
    }
    
    func sendNotification() throws {
        
        let content = UNMutableNotificationContent()
       
        content.title = "🎧 Soundverse AI"
        content.subtitle = "Your Personalized AI Playlist is Ready!"
        content.body = "Tap to explore your new AI-generated music mix. 🎶"
        content.userInfo = [
            "icon":"sparkles",
            "text":"Your Personalized AI Playlist is Ready!",
            "url":"https://www.loudly.com/music/ai-music-generator"
        ]
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )
        
        guard authorizationStatus.isSuccess else {
            if let error =  authorizationStatus.error {
                throw NotificationServiceError.unknown(error.localizedDescription)
            }else {
                throw NotificationServiceError.notAuthorized
            }
        }
        
        requestPermission()
        
        notificationCenter.add(request) { error in
            if let error {
                debugPrint(error)
                return
            }
        }
        
        print("SUCCESS")
        
    }
}

extension NotificationService: UNUserNotificationCenterDelegate {
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
       

        addNotifications(response.notification)
        
        openWebpage(response.notification)
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.banner,.sound])
        addNotifications(notification)
        
    }
    
    
    
    private func openWebpage(_ notification: UNNotification){
        let userInfo = notification.request.content.userInfo
        if let urlString = userInfo["url"] as? String,
           let url = URL(string: urlString) {
            print("🔗 Opening website: \(urlString)")
            
            DispatchQueue.main.async {
                UIApplication.shared.open(url)
            }
        }
    }
    
    private func addNotifications(_ notification: UNNotification) {
        let userInfo = notification.request.content.userInfo
       
        if let icon = userInfo[AnyHashable("icon")] as? String,
           let text = userInfo[AnyHashable("text")] as? String{
            
                
            let notificationItem = NotificationItem(icon: icon, text: text)
           
            notifications.append(notificationItem)
            
            unReaded = true
            showNotificationAlert = true
            
        }
    }
    

}
