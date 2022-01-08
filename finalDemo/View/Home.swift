//
//  Home.swift
//  finalDemo
//
//  Created by BirTakım Yazılım on 8.01.2022.
//

import SwiftUI

struct Home: View {
    
    @StateObject var HomeModel = HomeViewModel()
    var body: some View {
        
        ZStack {
            VStack(spacing: 10){
                HStack(spacing: 15){
                    Button(action: {
                        withAnimation(.easeIn){HomeModel.showMenu.toggle()}
                    }, label: {
                        Image(systemName: "line.horizontal.3")
                            .font(.title)
                            .foregroundColor(.green)
                    })
                    Text(HomeModel.userLocation == nil ? "Locating..." : "Deliver to")
                        .foregroundColor(.black)
                    Text(HomeModel.userAddress)
                        .font(.caption)
                        .fontWeight(.heavy)
                        .foregroundColor(.green)
                    Spacer(minLength: 0)
                }
                .padding([.horizontal, .top])
                
                Divider()
                
                HStack(spacing: 15){
                    TextField("search", text: $HomeModel.search)
                    
                    if HomeModel.search != "" {
                        Button(action: {}, label: {
                            Image(systemName: "magnifyingglass")
                                .font(.title2)
                                .foregroundColor(.gray)
                        })
                            .animation(.easeIn)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                Divider()
                
                ScrollView(.vertical, showsIndicators: false, content: {
                    
                    VStack(spacing: 25) {
                        
                        ForEach(HomeModel.items){ item in
                            
                            //item view
                            ZStack(alignment: Alignment(horizontal: .center,
                                                        vertical: .center), content: {
                                ItemView(item: item)
                                
                                HStack{
                                    
                                    Text("FREE DELIVERY")
                                        .foregroundColor(.white)
                                        .padding(.vertical, 10)
                                        .padding(.horizontal)
                                        .background(Color.red)
                                    
                                    Spacer(minLength: 0)
                                    
                                    Button(action: {}, label: {
                                        
                                        Image(systemName: "plus")
                                            .foregroundColor(.white)
                                            .padding(10)
                                            .background(Color.red)
                                            .clipShape(Circle())
                                    })
                                }
                                .padding(.trailing, 10)
                                .padding(.top, 10)
                            })
                            .frame(width: UIScreen.main.bounds.width - 30)
                        }
                    }
                    .padding(.top, 10)
                })
            }
            
            //hamburger menu
            HStack{
                Menu(homeData: HomeModel)
                //left to right
                    .offset(x: HomeModel.showMenu ? 0 : -UIScreen.main.bounds.width / 1.6)
                Spacer(minLength: 0)
            }
            .background(
                Color.black.opacity(HomeModel.showMenu ? 0.3 : 0).ignoresSafeArea())
                
                //close when touch gap area
            .onTapGesture(perform: {
                withAnimation(.easeIn){HomeModel.showMenu.toggle()}
            })
            
            //non closable aler if persmission denied
            if HomeModel.noLocation {
                Text("please enable location access!")
                    .foregroundColor(.red)
                    .frame(width: UIScreen.main.bounds.width - 100, height: 120)
                    .background(.white)
                    .cornerRadius(10)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.3).ignoresSafeArea())
            }
        }
        .onAppear(perform: {
            //call location delegate
            HomeModel.locationManager.delegate = HomeModel
           
        })
    }
}

//struct Home_Previews: PreviewProvider {
//    static var previews: some View {
//        Home()
//    }
//}
