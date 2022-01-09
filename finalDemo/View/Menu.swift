//
//  Menu.swift
//  finalDemo
//
//  Created by BirTakım Yazılım on 8.01.2022.
//

import SwiftUI

struct Menu: View {
    
    @ObservedObject var homeData: HomeViewModel
    var body: some View {
        
        VStack{
         
            NavigationLink(destination: CartView(homeData: homeData)) {
                    HStack(spacing: 15){
                        Image(systemName: "cart")
                            .font(.title)
                            .foregroundColor(Color.green)
                        Text("cart")
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                        Spacer(minLength: 0)
                    }
                    .padding()
            }
            
            Spacer()
            
            HStack{
                
                Spacer()
                
                Text("version 1998")
                    .fontWeight(.bold)
                    .foregroundColor(.green)
            }
            .padding(10)
        }
        .padding([.top, .trailing])
        .frame(width: UIScreen.main.bounds.width / 1.6)
        .background(Color.white.ignoresSafeArea())
    }
}


