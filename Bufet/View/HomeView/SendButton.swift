//
//  SendButton.swift
//  Bufet
//
//  Created by Razvan Rujoiu on 09.12.2021.
//

import SwiftUI

struct SendButton: View {
    @EnvironmentObject var capturedImage: CapturedImage
    @Binding var isShowingMail: Bool
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            Button {
                arView.snapshot(saveToHDR: false) { image in
                    if let imageData = image!.pngData() {
                        capturedImage.image = UIImage(data: imageData)!
                        isShowingMail = true
                    }
                }
            } label: {
                Image("ShareScreen")
                    .resizable()
                    .aspectRatio(contentMode:.fit)
                    .frame(width: 66, height: 66, alignment: .center)
            }
        }
    }
}
