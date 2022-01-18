
import SwiftUI

struct Menu: View {
    
    @ObservedObject var homeData: HomeViewModel
    var body: some View {
        
        VStack{
         
            NavigationLink(destination: CartView(homeData: homeData)) {
                    HStack(spacing: 15){
                        Image(systemName: "cart")
                            .font(.title)
                            .foregroundColor(Color.purple)
                        Text("cart")
                            .fontWeight(.bold)
                            .foregroundColor(.pink)
                        Spacer(minLength: 0)
                    }
                    .padding()
            }
            
            Spacer()
            
        }
        .padding([.top, .trailing])
        .frame(width: UIScreen.main.bounds.width / 1.6)
        .background(Color.white.ignoresSafeArea())
    }
}


