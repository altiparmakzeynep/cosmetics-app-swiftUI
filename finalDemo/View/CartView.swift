
import SwiftUI
import SDWebImageSwiftUI

struct CartView: View {
    @ObservedObject var homeData: HomeViewModel
    @Environment(\.presentationMode) var present
    
    var lazy = [GridItem(), GridItem()] // 2 items in 1 row
    
    var body: some View {
        VStack {
            HStack(spacing: 20) {
                Button(action: {present.wrappedValue.dismiss()}) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 26, weight: .heavy))
                        .foregroundColor(.purple)
                }
                
                Text("My Cart")
                    .font(.title2)
                    .fontWeight(.heavy)
                    .foregroundColor(.black)
                
                Spacer()
            }
            .padding()
            
            ScrollView(.vertical, showsIndicators: false) {
                
                LazyVGrid(columns: lazy) {
                    
                    //cart item view
                    ForEach(homeData.cartItems) { cart in
                        HStack(spacing: 15) {
                            
                            WebImage(url: URL(string: cart.item.itemImage))
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 65, height: 65)
                                .cornerRadius(15)
                            
                            VStack(alignment: .leading,spacing: 3) {
                                
                                Text(cart.item.itemName)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.black)
                                
                                Text(cart.item.itemDetails)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.gray)
                                    .lineLimit(2)
                                
                                HStack(spacing: 5) {
                                    
                                    Text(homeData.getPrice(value: Float(truncating: cart.item.itemCost)))
                                        .font(.body)
                                        .fontWeight(.light)
                                        .foregroundColor(Color.black)
                                    
                                    Spacer(minLength: 0)
                                    
                                    //sub
                                    Button(action: {
                                        if cart.quantity > 1 {
                                            homeData.cartItems[homeData.getIndex(item: cart.item, isCartIndex: true)].quantity -= 1
                                        }
                                    }) {
                                        Image(systemName: "minus")
                                            .font(.system(size: 16, weight: .heavy))
                                            .foregroundColor(.black)
                                    }
                                    Text("\(cart.quantity)")
                                        .fontWeight(.heavy)
                                        .foregroundColor(.black)
                                        .padding(.vertical, 5)
                                        .padding(.horizontal, 10)
                                        .background(Color.black.opacity(0.06))
                                       
                                    Button(action: {
                                        homeData.cartItems[homeData.getIndex(item: cart.item, isCartIndex: true)].quantity += 1
                                    }) {
                                        
                                        Image(systemName: "plus")
                                            .font(.system(size: 16, weight: .heavy))
                                            .foregroundColor(.black)
                                    }
                                }
                            }
                        }
                        .padding()
                        .contextMenu{
                            //delete order
                            Button(action: {
                                
                                let index = homeData.getIndex(item: cart.item, isCartIndex: true)
                                
                                let itemIndex = homeData.getIndex(item: cart.item, isCartIndex: false)
                                
                                homeData.items[itemIndex].isAdded = false
                                homeData.filtered[itemIndex].isAdded = false

                                homeData.cartItems.remove(at: index)
                                
                            }) {
                                Text("remove")
                            }
                        }
                    }
                }
            }
            
            //bottom view
            
            VStack {
                HStack {
                    
                    Text("total")
                        .fontWeight(.heavy)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Text(homeData.calculateTotalPrice())
                        .font(.title)
                        .fontWeight(.heavy)
                        .foregroundColor(.black)
                }
                .padding([.top, .horizontal])
                
                Button(action: homeData.updateOrder) {
                    Text(homeData.ordered ? "cancel order" : "check out")
                        .font(.title2)
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 30)
                        .background(
                            Color(.purple)
                        )
                        .cornerRadius(15)
                }
            }
            .background(Color.white)
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

