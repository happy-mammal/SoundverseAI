//
//  ContentView.swift
//  SoundverseAI
//
//  Created by Yash Lalit on 27/02/25.
//

import SwiftUI

struct ContentView: View {
    
    @State private var textField:String = ""
    
    var body: some View {
        NavigationView {
            VStack{
                
                
                Spacer()
                
                VStack {
                    
                    TextField("Enter Something", text: $textField)
                    
                    
                    HStack{
                        
                        Image(systemName: "dice.fill")
                            .font(.title3)
                            .foregroundStyle(Color.white)
                            .padding(10)
                            .background(
                                Capsule()
                                    .fill(Color.gray.opacity(0.6)
                            )
                        )
                        
                        HStack{
                            Image(systemName: "dice.fill")
                                .font(.title3)
                                .foregroundStyle(Color.white)
                            
                            Text("SAAR-Voice")
                                .font(.subheadline)
                            }
                            .padding(10)
                            .background(
                                Capsule()
                                    .fill(Color.gray.opacity(0.6)
                            )
                        )
                        
                        HStack{
                            Image(systemName: "dice.fill")
                                .font(.title3)
                                .foregroundStyle(Color.white)
                            
                            Text("SAAR-Voice")
                                .font(.subheadline)
                            }
                            .padding(10)
                            .background(
                                Capsule()
                                    .fill(Color.gray.opacity(0.6)
                            )
                        )
                        
                    }
                    
                }
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray.opacity(0.4))
                )
                .padding()
                
            }
        }
    }
}

#Preview {
    ContentView()
}
