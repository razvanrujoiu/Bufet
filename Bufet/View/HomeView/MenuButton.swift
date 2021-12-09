//
//  MenuButton.swift
//  Bufet
//
//  Created by Razvan Rujoiu on 09.12.2021.
//

import SwiftUI

struct MenuButton: View {
    @Binding var isFoodModalPresented: Bool
    
    var body: some View {
        VStack(alignment: .trailing) {
            HStack {
                Spacer()
                Button {
                    isFoodModalPresented = true
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 22)
                            .foregroundColor(.white)
                        Image("001-hamburger")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(Color.init(hex: "#4ABFBB"))
                            .aspectRatio(contentMode:.fit)
                            .frame(width: 25, height: 25, alignment: .center)
                        
                    }
                    .frame(width: 45, height: 45, alignment: .center)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10))
                }
            }
            Spacer()
        }
    }
}

