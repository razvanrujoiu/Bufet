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
    
    var body: some View {
        ZStack {
            ZStack {
                Text(title)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(Color.black)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: -20, trailing: 0))
                    .frame(width: 170, height: 65, alignment: .center)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                HStack(alignment: .firstTextBaseline) {
                    Link(destination: URL(string: details.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!) {
                        Image("004-info-button")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.black)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 12, height: 12)
                            
                    }.padding(EdgeInsets(top: 0, leading: 5, bottom: 40, trailing: 0))
                    Spacer()
                }
            }
            AsyncImage(url: URL(string: image)!, placeholder: {Color.gray}, image: { image in
                Image(uiImage: image)
                    .resizable()
            }).aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100, alignment: .center)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 110, trailing: 0))
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
