//
//  CellTitle.swift
//  Bufet
//
//  Created by Razvan Rujoiu on 09.12.2021.
//

import SwiftUI

struct CellTitle: View {
    var title: String
    var body: some View {
        Text(title)
            .font(.system(size: 22, weight: .bold))
            .foregroundColor(Color.black)
            .padding(EdgeInsets(top: 0, leading: 0, bottom: -20, trailing: 0))
            .frame(width: 170, height: 65, alignment: .center)
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
    }
}
