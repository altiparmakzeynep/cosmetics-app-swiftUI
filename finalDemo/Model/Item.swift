

import SwiftUI

struct Item: Identifiable {
    
    var id: String
    var itemName: String
    var itemCost: NSNumber //kolay donusturulebilir oldugu icin kulllanılır
    var itemDetails: String
    var itemImage: String
    var itemRatings: String
    var itemShow: Bool
    var isAdded: Bool = false
}


