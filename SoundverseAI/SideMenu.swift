//
//  SideMenu.swift
//  SoundverseAI
//
//  Created by Yash Lalit on 27/02/25.
//

import SwiftUI

//A struct to store some info about side menu item
struct SideMenuItem: Identifiable{
    let id: String = UUID().uuidString
    let icon:String
    let title: String
}
struct SideMenu: View {
    
    //These are dummy menu items pre loaded
    private let items = [
        SideMenuItem(icon: "house", title: "Home"),
        SideMenuItem(icon: "magnifyingglass", title: "Search"),
        SideMenuItem(icon: "books.vertical.fill", title: "Library"),
        SideMenuItem(icon: "gear", title: "Settings"),
        SideMenuItem(icon: "person.3.fill", title: "Community")
        
    ]
    
    //Used this to track current selected item
    @State private var selectedItem = "Home"
    
    //Used to make sure after the side menu appers then only items are shown
    @State private var showItems = false
    
    var body: some View {
        ZStack{
           
            //Side menu background
            background
            
            //Side menu foreground
            foreground
            
        }
        .ignoresSafeArea()
        .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .leading)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now()+1.5){
                withAnimation(.spring) {
                    showItems = true
                }
            }
        }
        
        
    }
}

//Components
extension SideMenu {
    
    //MARK: Background for side menu
    var background: some View {
        LinearGradient(
            colors: [
                Color.purple,
                Color.indigo,
                Color.pink,
                Color(uiColor: UIColor.systemBackground)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .frame(width: 256)
        .shadow(color:Color.black.opacity(0.3), radius: 5)
    }
    
    //Profile image section
    var profileImage: some View {
        Image("ProfileImage")
            .resizable()
            .scaledToFit()
            .frame(width:120)
            .clipShape(Circle())
    }
    
    //Profile name section
    var profileName: some View {
        Text("Yash Lalit")
            .font(.title)
            .fontWeight(.semibold)
            .foregroundStyle(Color.white)
    }
    
    //Menu item tile
    func menuTile(_ item: SideMenuItem) -> some View{
        Button {
            selectedItem = item.title
        } label: {
            HStack(spacing:15){
                Image(systemName: item.icon)
                    .frame(width: 20)
                    .foregroundStyle(Color.white)
                
                Text(item.title)
                    .font(.title3)
                    .foregroundStyle(Color.white)
            }
            .padding()
            .frame(maxWidth: .infinity,alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(selectedItem == item.title ? Color.white.opacity(0.2) : Color.clear)
            )
        }
    }
    
    //Side menu items list
    var menuList: some View {
        ForEach(items,id: \.id) { item in
            menuTile(item)

        }
    }
    
    //MARK: Side menu foreground
    var foreground: some View {
        VStack(alignment:.leading){
            
            profileImage
            
            profileName
            
            if showItems {
                menuList
            }
            
            Spacer()
            
        }
        .padding(.horizontal)
        .frame(maxWidth: 256,alignment: .leading)
        .padding(.vertical,80)
        .bold()
    }
}

#Preview {
    SideMenu()
}
