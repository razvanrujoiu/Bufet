//
//  FoodItem.swift
//  Bufet
//
//  Created by Razvan Rujoiu on 05.12.2021.
//

import SwiftUI

struct FoodItem: View {
    let title: String
    let details: String
    let image: String
    let action: () -> Void
    @State private var showWebView = false
    
    var body: some View {
        ZStack {
            ZStack {
                CellTitle(title: title)
                InfoButton(showWebView: $showWebView, details: details)
            }
            CellImage(image: image)
        }.frame(width: 170, height: 150)
            .onTapGesture {
                self.action()
            }
    }
}

#if DEBUG
struct FoodItem_Previews: PreviewProvider {
    static var previews: some View {
        FoodItem(title: "Burger",
                 details: "https://en.wikipedia.org/wiki/Burger",
                 image: "https://s-on-staging.s3.eu-central-1.amazonaws.com/uploads/food_item/image/23/Burger.png",
                 action: {})
    }
}
#endif





