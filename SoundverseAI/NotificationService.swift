//
//  NotificationServic.swift
//  SoundverseAI
//
//  Created by Yash Lalit on 27/02/25.
//

import Foundation
import UserNotifications
import UIKit


class NotificationService: NSObject, ObservableObject {
    
    //These are dummy notificationed pre loaded
    let dummyNotifications = [
       NotificationItem(icon: "waveform.path", text: "🔊 Soundwave analysis complete—try now!"),
       NotificationItem(icon: "music.mic", text: "🎤 Your favorite artist released a new song!"),
       NotificationItem(icon: "megaphone.fill", text: "🚀 Soundverse AI update is live!"),
       NotificationItem(icon: "person.2.fill", text: "Your friend joined Soundverse AI! 👥"),
       NotificationItem(icon: "star.fill", text: "Exclusive playlist curated for you! 🌟"),
    ]
    
    //A flag to indicate new notifications are there and are unreaded
    @Published var unReaded:Bool = false
    
    //
    @Published var showNotificationAlert:Bool = false
    
    //New notifications are stored here
    @Published var notifications:[NotificationItem] = []
    
    //A status of notification permission check/request
    private var authorizationStatus:(isSuccess:Bool, error: Error?) = (false,nil)
    
    //Instance of notification for current app
    private let notificationCenter: UNUserNotificationCenter
    
    //MARK: Singleton for notification service
    static let shared = NotificationService()
    
    //Private internal init so no one can use init of this class outside
    override private init() {
        self.notificationCenter = UNUserNotificationCenter.current()
        super.init()
        notificationCenter.delegate = self
    }
    
    //MARK: Function to request authorization of notifications
    func requestPermission() {
        notificationCenter.requestAuthorization(options: [.alert,.sound]) { isSuccess, error in
            
            if let error {
                self.authorizationStatus = (false,error)
                return
            }
            
            self.authorizationStatus = (isSuccess,nil)
        }
    }
    
    //MARK: Funtion to send notification
    func sendNotification() -> Bool? {
        
        //Setting up the content for notification
        let content = UNMutableNotificationContent()
       
        content.title = "🎧 Soundverse AI"
        content.subtitle = "Your Personalized AI Playlist is Ready!"
        content.body = "Tap to explore your new AI-generated music mix. 🎶"
        content.userInfo = [
            "icon":"sparkles",
            "text":"Your Personalized AI Playlist is Ready!",
            "url":"https://suno.com/home"
        ]
        content.sound = .default
        
        //Setting up the trigger i.e to send notification after 5 seconds
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        //Setting up the request for the notification
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )
        
        //Making sure before request is sent authorization is provided
        requestPermission()
       
        //Check for authorization status
        guard authorizationStatus.isSuccess else {
            //If authorization status is not sucess then check if any error occured
            if let error =  authorizationStatus.error {
                //If error send false and abort
                debugPrint(error)
                return false
            }
            
            //If no error means authorization is not granted and abort
            return nil
        }
        
        //If all well then create notification request
        notificationCenter.add(request)
        
        //All well send back as true
        return true
        
    }
}

//A delegate used to listen for incoming notification when in foreground and perform action on tap of notification
extension NotificationService: UNUserNotificationCenterDelegate {
    
    
    
    //MARK: Used to handle when a notification is tapped reqirect the app to open a webpage similar to Soundverse AI
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
       

        addNotifications(response.notification,isBackground: true)
        
        openWebpage(response.notification)
        
    }
    
    //MARK: Used to handle foreground activity when notification is received
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
       
        addNotifications(notification,isBackground: false)
        
    }
    
    
    //MARK: Function to open webpage
    private func openWebpage(_ notification: UNNotification){
        let userInfo = notification.request.content.userInfo
        if let urlString = userInfo["url"] as? String,
           let url = URL(string: urlString) {
            
            DispatchQueue.main.async {
                UIApplication.shared.open(url)
            }
        }
    }
    
    //MARK: Function to add notification to notifications list & marking unread flag
    private func addNotifications(_ notification: UNNotification, isBackground:Bool) {
        let userInfo = notification.request.content.userInfo
       
        if let icon = userInfo[AnyHashable("icon")] as? String,
           let text = userInfo[AnyHashable("text")] as? String{
            
            debugPrint(notification.request.identifier)
            let notificationItem = NotificationItem(id: notification.request.identifier, icon: icon, text: text)
           
            if !notifications.contains(where: { $0.id == notificationItem.id }) {
                notifications.append(notificationItem)
            }
            
            unReaded = true
            
            if !isBackground {
                showNotificationAlert = true
            }
            
        }
    }
    

}
