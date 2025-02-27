//
//  NotificationsScreen.swift
//  SoundverseAI
//
//  Created by Yash Lalit on 27/02/25.
//

import SwiftUI

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
    
    @StateObject private var notificationService = NotificationService.shared
    
    @State private var showConfirmation = false
    
    var body: some View {
        List{
            
            if !notificationService.notifications.isEmpty {
                Section{
                    ForEach(notificationService.notifications) { item in
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
                } header: {
                    Text("Today")
                        .textCase(nil)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.primary)
                }
            }
            
            
            Section  {
                ForEach(notificationService.dummyNotifications) { item in
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
            } header: {
                Text("This Week")
                    .textCase(nil)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.primary)
                
            }
        }
        .animation(.spring, value: notificationService.unReaded)
        .confirmationDialog("What you wann'a do ?", isPresented: $showConfirmation, actions: {
            Button("Send Notification") {
                do {
                   try notificationService.sendNotification()
                }catch {
                    
                }
            }
        })
        .listStyle(.plain)
        .scrollIndicators(.hidden)
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            notificationService.requestPermission()
        }
        .onDisappear {
            notificationService.unReaded = false
        }
    }
}

#Preview {
    NotificationsScreen()
}
