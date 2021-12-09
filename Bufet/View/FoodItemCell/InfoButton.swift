//
//  InfoButton.swift
//  Bufet
//
//  Created by Razvan Rujoiu on 09.12.2021.
//

import SwiftUI

struct InfoButton: View {
    @Binding var showWebView: Bool
    var details: String
    
    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Button {
                showWebView.toggle()
            } label: {
                Image("004-info-button")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(.black)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 12, height: 12)
            }
            .sheet(isPresented: $showWebView) {
                WebView(url: URL(string: details.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!)
            }
            .padding(EdgeInsets(top: 0, leading: 5, bottom: 40, trailing: 0))
            Spacer()
        }
    }
}
