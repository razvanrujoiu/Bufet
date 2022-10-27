//
//  CellImage.swift
//  Bufet
//
//  Created by Razvan Rujoiu on 09.12.2021.
//

import SwiftUI

struct CellImage: View {
    var image: String
    var body: some View {
        AsyncImage(url: URL(string: image)!, image: { image in
            Image(uiImage: image)
                .resizable()
        }).aspectRatio(contentMode: .fit)
            .frame(width: 100, height: 100, alignment: .center)
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 110, trailing: 0))
    }
}
