
import SwiftUI

struct Cart: Identifiable { //protokol, tanımlanabilir
    
    var id = UUID().uuidString //unique olmasını sağlar
    var item: Item
    var quantity: Int
}
