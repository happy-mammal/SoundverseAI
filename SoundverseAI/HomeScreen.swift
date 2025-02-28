//
//  Test.swift
//  SoundverseAI
//
//  Created by Yash Lalit on 27/02/25.
//

import SwiftUI

//A struct to store some info about chip item
struct ChipInfo: Identifiable{
    var id:String = UUID().uuidString
    let systemImage: String?
    let title: String
}

struct HomeScreen: View {
    
    //These are dummy chip data pre loaded
    private let chipData = [
        ChipInfo(systemImage: "sparkles", title: "SAAR-Voice"),
        ChipInfo(systemImage: nil, title: "Seperate Stems"),
        ChipInfo(systemImage: nil, title: "SAAR-Chat"),
        ChipInfo(systemImage: nil, title: "Extended Music"),
        ChipInfo(systemImage: nil, title: "Auto-Complete Song"),
        ChipInfo(systemImage: nil, title: "Generate Lyrics")
        
    ]
    
    //These are dummy suggesttions pre loaded
    private let suggestions = [
        "Create an energetic pop song with catchy hooks and vibrant blend of guitars",
        "Compose a futuristic electronic track with cutting-edge synth sound and pulsing"
    ]
    
    //Notification Service
    @EnvironmentObject private var notificationService:NotificationService
    
    //Flag to show/hide side menu
    @State var showMenu:Bool = false

    @State private var chatInput:String = ""
    
    @State private var showNotificationsScreen: Bool = false
    
    @State private var thinking: Bool = true
    
    @State private var chats: [String] = []
    
    var body: some View {
        
        ZStack{
            NavigationStack{
                VStack {
                    
                    Spacer()
                    
                    if chats.isEmpty {
                        header
                        
                        suggestionList
                    }else {
                        chatList
                    }
                    
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
            
            //MARK: Side menu
            SideMenu()
                .offset(x: showMenu ? 0 : -270)
                .animation(.spring, value: showMenu)
                
                
        }
        .gesture(DragGesture().onEnded({ value in
            //Drag gesture used to detect left & right swipe to show/hide side menu
            if value.translation.width < -50 {

                showMenu = false
            }else if value.translation.width > 50 {
                showMenu = true
            }
        }))
        
        
    }
        
}

//Functions
extension HomeScreen{
    //MARK: Function for dummy random prompt
    func onDiceButtonClicked(){
        chatInput = "This is a dummy random input chat prompt wanna try!"
    }
    //MARK: Function to send chat
    func onSendChatButtonClicked(){
        if(!chatInput.isEmpty) {
            chats.append(chatInput)
            chatInput = ""
            DispatchQueue.main.asyncAfter(deadline: .now()+1){
                chats.append("This is dummy replay man set from a person completing soundverse internship assignment.")
            }
        }
    }
}

//Components
extension HomeScreen {
    
    //MARK: Header
    var header: some View {
        Text("Generate AI Music with the ultimate music assistant")
            .font(.title)
            .fontWeight(.semibold)
            .multilineTextAlignment(.center)
            .padding()
    }
    
    //MARK: Promt suggestions list
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
    
    //MARK: App features list
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
    
    //MARK: Chat input panel with text field, random prompt, send button
    var inputPanel: some View {
        VStack {
            TextField("Ask anything", text: $chatInput, axis: .vertical)
                .lineLimit(4)
                   
            HStack {
                
                Button {
                    onDiceButtonClicked()
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
                    onSendChatButtonClicked()
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
    
    //MARK: Toolbar leading items
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
    
    //MARK: Toolbar trailing items
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
    
    //MARK: Chat tile
    func chatTile(_ chat: String) -> some View {
        Text(chat)
            .font(.headline)
            .padding()
            .background(RoundedRectangle(cornerRadius: 15)
                .fill(Color.purple.opacity(0.3)))
        
            .listRowBackground(
                Color.clear
            )
            .listRowSeparator(.hidden)
    }
    
    //MARK: Chat list
    var chatList: some View {
        List(chats, id: \.self) { chat in
            
            chatTile(chat)
        }
        .animation(.spring, value: chats)
        .scrollContentBackground(.hidden)
        .scrollIndicators(.hidden)
    }
    
}

#Preview {
    HomeScreen()
    .environmentObject(NotificationService.shared)
}
