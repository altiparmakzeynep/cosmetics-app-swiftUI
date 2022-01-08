//
//  ItemView.swift
//  finalDemo
//
//  Created by BirTakım Yazılım on 8.01.2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct ItemView: View {
    var item: Item
    var body: some View {
        VStack{
            //download image
            WebImage(url: URL(string: item.itemImage))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.main.bounds.width - 30, height: 250)
            
            HStack(spacing: 8){
                
                Text(item.itemName)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                Spacer(minLength: 0)
                
                // ratings view
                ForEach(1...5, id: \.self){ index in
                    
                    Image(systemName: "star.fill")
                        .foregroundColor(index <= Int(item.itemRatings) ?? 0 ?
                                         Color(.green) : Color(.gray))
                }
            }
            
            HStack{
                
                Text(item.itemDetails)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .lineLimit(2)
                
                Spacer(minLength: 0)
            }
        }
    }
}

