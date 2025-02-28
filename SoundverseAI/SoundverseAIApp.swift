//
//  SoundverseAIApp.swift
//  SoundverseAI
//
//  Created by Yash Lalit on 27/02/25.
//

import SwiftUI

@main
struct SoundverseAIApp: App {
    
    //Intializing notification service with single instance
    @StateObject private var notificationService = NotificationService.shared
    
    var body: some Scene {
        WindowGroup {
           
             HomeScreen()
            .environmentObject(notificationService)
            
        }
    }
}
