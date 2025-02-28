//
//  NotificationsScreen.swift
//  SoundverseAI
//
//  Created by Yash Lalit on 27/02/25.
//

import SwiftUI

//A struct to store some info about notification item
struct NotificationItem: Identifiable {
    let id: String
    let icon: String
    let text: String
    
    init(id: String = UUID().uuidString, icon: String, text:String) {
        self.id = id
        self.icon = icon
        self.text = text
    }
}

struct NotificationsScreen: View {
    
    //Notification Service
    @EnvironmentObject private var notificationService:NotificationService
    
    //Confirmation of action when notification is pressed (1. Show Notification)
    @State private var showConfirmation = false
    
    //Alert dialog flag
    @State private var showAlert = false
    
    //Alear dialog message
    @State private var alertMessage = ""
    
    
    var body: some View {
        //Tried to achive instagram like notification UI as asked.
        List{
            
            //Show today's notifications if they appear its dynamic
            if !notificationService.notifications.isEmpty {
                todayNotifications
            }
            
            //Show this week's notification based on dummy data
            thisWeekNotifications
            
        }
        .animation(.spring, value: notificationService.unReaded)
        .alert(
            "Alert",
            isPresented: $showAlert,
            actions: {},
            message: {Text(alertMessage)}
        )
        .confirmationDialog(
            "What you wann'a do ?",
            isPresented: $showConfirmation,
            actions: {
                Button("Send Notification") {
                    onSendNotification()
                }
        })
        .listStyle(.plain)
        .scrollIndicators(.hidden)
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            //Request for notification permission when screen is opened
            notificationService.requestPermission()
        }
        .onDisappear {
            //Making sure the flag for unread notification is unset
            notificationService.unReaded = false
        }
    }
}

//Functions
extension NotificationsScreen {
    func onSendNotification(){
        if let isSuccess = notificationService.sendNotification() {
            if !isSuccess {
                alertMessage = "Oops someting went wrong!"
                showAlert = true
            }
        }else {
            alertMessage = "Notification permission is not allowed. Please go to Settings > Apps > SoundverseAI > Notifications and enable the permission. Then try again."
            showAlert = true
        }
    }
}

//Components
extension NotificationsScreen {
    
    //Today's Notification Section [Dynamic]
    var todayNotifications: some View {
        Section{
            ForEach(notificationService.notifications) { item in
                notificationTile(item)
            }
        } header: {
            Text("Today")
                .textCase(nil)
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(Color.primary)
        }
    }
    
    //This week's notification Section [Dummy]
    var thisWeekNotifications: some View {
        Section  {
            ForEach(notificationService.dummyNotifications) { item in
                notificationTile(item)
            }
        } header: {
            Text("This Week")
                .textCase(nil)
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(Color.primary)
            
        }
    }
    
    //Notification Tile 
    func notificationTile(_ item:NotificationItem) -> some View {
        HStack{
            Image(systemName: item.icon)
                .frame(
                    width: 40, height: 40
                )
                .background(
                    Circle().fill(Color.indigo.opacity(0.4))
                )
            Text(item.text)
                .font(.headline)
               
        }
        .onTapGesture {
            showConfirmation = true
        }
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
    }
}
#Preview {
    NotificationsScreen()
        .environmentObject(NotificationService.shared)
}
