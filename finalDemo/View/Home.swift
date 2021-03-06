
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
                            .foregroundColor(.purple)
                    })
                    Text(HomeModel.userLocation == nil ? "Locating..." : "Deliver to")
                        .foregroundColor(.black)
                    Text(HomeModel.userAddress)
                        .font(.caption)
                        .fontWeight(.heavy)
                        .foregroundColor(.pink)
                    Spacer(minLength: 0)
                }
                .padding([.horizontal, .top])
                
                Divider()
                
                HStack(spacing: 15){
                    
                    Image(systemName: "magnifyingglass")
                        .font(.title2)
                        .foregroundColor(.gray)
                    
                    TextField("search", text: $HomeModel.search)
                    
               
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                Divider()
                
                if HomeModel.items.isEmpty {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                else {
                    ScrollView(.vertical, showsIndicators: false, content: {
                        
                        VStack(spacing: 25) {
                            
                            //artık filtered donmesi lazim
                            ForEach(HomeModel.filtered){ item in
                                
                                //item view
                                ZStack(alignment: Alignment(horizontal: .center,
                                                            vertical: .center), content: {
                                    ItemView(item: item)
                                    
                                    if item.itemShow {
                                        HStack{
                                            
                                            Spacer(minLength: 0)
                                            
                                            Button(action: {
                                                HomeModel.addToCart(item: item)
                                            }, label: {
                                                
                                                Image(systemName: item.isAdded ? "checkmark" : "plus")
                                                    .foregroundColor(.white)
                                                    .padding(10)
                                                    .background(item.isAdded ? Color.green : Color.purple)
                                                    .clipShape(Circle())
                                            })
                                        }
                                        .padding(.trailing, 10)
                                        .padding(.top, 150)
                                    }
                                    
                                })
                                .frame(width: UIScreen.main.bounds.width - 30)
                            }
                        }
                        .padding(.top, 10)
                    })
                }
            }
            
            //hamburger menu
            HStack{
                Menu(homeData: HomeModel)
                //left to right
                    .offset(x: HomeModel.showMenu ? 0 : -UIScreen.main.bounds.width / 1.6)
                Spacer(minLength: 0) //yatay dikey denge
            }
            .background(
                Color.black.opacity(HomeModel.showMenu ? 0.3 : 0).ignoresSafeArea())
                
                //close when touch gap area
            .onTapGesture(perform: {
                withAnimation(.easeIn){HomeModel.showMenu.toggle()}
                //efektin yavaş başlayıp daha hızlı bittiği bir animasyon.
            })
            
            //non closable alert if persmission denied
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
        .onChange(of: HomeModel.search, perform: { value in
            
            //search suresi
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                
                if value == HomeModel.search && HomeModel.search != "" {
                    //search data
                    HomeModel.searchData()
                }
            }
            
            if HomeModel.search == "" {
                //reset all data
                withAnimation(.linear) {
                    HomeModel.filtered = HomeModel.items
                }
            }
        })
    }
}
