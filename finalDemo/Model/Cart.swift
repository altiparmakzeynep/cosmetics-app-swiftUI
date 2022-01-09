//
//  Cart.swift
//  finalDemo
//
//  Created by BirTakım Yazılım on 9.01.2022.
//

import SwiftUI

struct Cart: Identifiable {
    
    var id = UUID().uuidString
    var item: Item
    var quantity: Int
}
