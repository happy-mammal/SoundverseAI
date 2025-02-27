//
//  SideMenu.swift
//  SoundverseAI
//
//  Created by Yash Lalit on 27/02/25.
//

import SwiftUI

struct SideMenuItem: Identifiable{
    let id: String = UUID().uuidString
    let icon:String
    let title: String
}
struct SideMenu: View {
    
    private let items = [
        SideMenuItem(icon: "house", title: "Home"),
        SideMenuItem(icon: "magnifyingglass", title: "Search"),
        SideMenuItem(icon: "books.vertical.fill", title: "Library"),
        SideMenuItem(icon: "gear", title: "Settings"),
        SideMenuItem(icon: "person.3.fill", title: "Community")
        
    ]
    
    @State private var selectedItem = "Home"
    
    @State private var showItems = false
    var body: some View {
        ZStack{
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
            
            VStack(alignment:.leading){
                
                
                Image("ProfileImage")
                    .resizable()
                    .scaledToFit()
                    .frame(width:120)
                    .clipShape(Circle())
                
                Text("Yash Lalit")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.white)
                
                
                if showItems {
                    ForEach(items,id: \.id) { item in
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
                }
                
                Spacer()
                
            }
            .padding(.horizontal)
            .frame(maxWidth: 256,alignment: .leading)
            .padding(.vertical,80)
            .bold()
            
            
            
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

#Preview {
    SideMenu()
}
