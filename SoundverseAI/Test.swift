//
//  Test.swift
//  SoundverseAI
//
//  Created by Yash Lalit on 27/02/25.
//

import SwiftUI

struct ChipInfo: Identifiable{
    var id:String = UUID().uuidString
    let systemImage: String?
    let title: String
}

struct Test: View {
    
    @StateObject private var notificationService = NotificationService.shared
    let chipData = [
        ChipInfo(systemImage: "sparkles", title: "SAAR-Voice"),
        ChipInfo(systemImage: nil, title: "Seperate Stems"),
        ChipInfo(systemImage: nil, title: "SAAR-Chat"),
        ChipInfo(systemImage: nil, title: "Extended Music"),
        ChipInfo(systemImage: nil, title: "Auto-Complete Song"),
        ChipInfo(systemImage: nil, title: "Generate Lyrics")
        
    ]
    
    @State var showMenu:Bool = false
    
    let suggestions = [
        "Create an energetic pop song with catchy hooks and vibrant blend of guitars",
        "Compose a futuristic electronic track with cutting-edge synth sound and pulsing"
    ]
    
    @State private var textField:String = ""
    
    @State private var showNotificationsScreen: Bool = false
    
    var body: some View {
        
        ZStack{
            NavigationStack {
                VStack {
                    
                    Spacer()
                    
                    header
                    
                    suggestionList
                    
                    Spacer()
                    
                    featureList
                    
                    inputPanel
                    
                }
                
                .alert("New notification", isPresented: $notificationService.showNotificationAlert, actions: {
                    
                }, message: {Text(notificationService.notifications.last?.text ?? "")})
                .navigationDestination(isPresented: $showNotificationsScreen, destination: {
                    NotificationsScreen()
                })
                .toolbar {
                    toolbarLeadingItems
                    
                    
                    ToolbarItem(placement: .principal) {
                        Text("Soundverse AI")
                            .font(.headline)
                    }
                    
                    toolbarTrailingItems
                    
                }
                
                
                
            }
            
            SideMenu()
                .offset(x: showMenu ? 0 : -270)
                .transition(.move(edge: .leading))
                .animation(.spring, value: showMenu)
                
        }
        .gesture(DragGesture().onEnded({ value in
            if value.translation.width < -50 {
//                withAnimation(.easeIn) {
//                    
//                }
                showMenu = false
            }else if value.translation.width > 50 {
//                withAnimation(.easeIn) {
//                    
//                }
                showMenu = true
            }
        }))
        
        
    }
        
}


extension Test {
    
    var header: some View {
        Text("Generate AI Music with the ultimate music assistant")
            .font(.title)
            .fontWeight(.semibold)
            .multilineTextAlignment(.center)
            .padding()
    }
    
    var suggestionList: some View {
        
        ForEach(suggestions, id: \.self) { value in
            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
                .truncationMode(.tail)
                .lineLimit(1)
                .padding(10)
                .background(
                    Capsule()
                        .fill(Color.indigo.opacity(0.3))
                )
                .padding(10)
        }
        
    }
    
    var featureList: some View {
        
        ScrollView(.horizontal) {
            HStack {
                ForEach(chipData) { data in
                    Button {
                        
                    } label: {
                        HStack{
                            if let icon = data.systemImage {
                                Image(systemName: icon)
                                    .font(.callout)
                            }
                            Text(data.title)
                                .font(.callout)
                                .fontWeight(.semibold)
                        }
                        .padding(8)
                        .background(
                            Capsule()
                                .stroke(lineWidth: 1)
                        )
                    }
                    .tint(Color.indigo)
                }
            }
            .padding(10)
        }
        .scrollIndicators(.hidden)
    }
    
    var inputPanel: some View {
        VStack {
            TextField("Ask anything", text: $textField,axis: .vertical)
                .lineLimit(4)
            
            HStack {
                
                Button {
                    
                } label: {
                    Image(systemName: "dice.fill")
                        .font(.title3)
                        .foregroundStyle(Color.white)
                        .padding(10)
                        .frame(
                            width: 50,
                            height: 50
                        )
                        .background(
                            Capsule()
                                .fill(Color.pink)
                        )
                }
                
                
                Spacer()
                
                Button {
                    
                } label: {
                    Image(systemName: "arrow.up")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.white)
                        .padding(10)
                        .frame(
                            width: 50,
                            height: 50
                        )
                        .background(
                            Capsule()
                                .fill(Color.pink)
                        )
                }
                
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .stroke(lineWidth: 2)
                .fill(Color.gray.opacity(0.2))
        )
        .padding()
    }
    
    var toolbarLeadingItems: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button {
                withAnimation(.easeIn) {
                    showMenu = true
                }
            } label: {
                Image(systemName: "line.3.horizontal.decrease.circle")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.purple)
                    .padding(10)
                    .frame(width: 40, height: 40)
                    .background(
                        Circle().fill(Color.purple.opacity(0.3))
                    )
                
            }
            
        }
    }
    
    var toolbarTrailingItems: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            HStack(spacing: 10) {
                
                Button {
                    showNotificationsScreen = true
                } label: {
                    Image(systemName: notificationService.unReaded ? "bell.badge.fill": "bell.fill")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .frame(width: 40, height: 40)
                        .foregroundStyle(Color.purple)
                        
                       
                }
                
                Image("ProfileImage")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                
            }
        }
    }
    
}

#Preview {
    Test()
}
