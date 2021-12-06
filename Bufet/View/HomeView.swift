//
//  ContentView.swift
//  Bufet
//
//  Created by Razvan Rujoiu on 04.12.2021.
//

import SwiftUI
import RealityKit
import MessageUI

struct HomeView : View {
    
    @State var isFoodModalPresented: Bool = false
    @State private var isShowingMail: Bool = false
    @State private var isShowingAlert: Bool = false
    @StateObject var selectedFood: SelectedFood = SelectedFood()
    @State var capturedImage = CapturedImage()
//    @EnvironmentObject var capturedImage: CapturedImage
    
    
    
    var body: some View {
            ZStack {
                ARViewContainer(capturedImage: $capturedImage).edgesIgnoringSafeArea(.all)
                VStack(alignment: .trailing) {
                    HStack {
                        Spacer()
                        Button {
                            isFoodModalPresented = true
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 25)
                                    .foregroundColor(.white)
                                Image("001-hamburger")
                                    .resizable()
                                    .renderingMode(.template)
                                    .foregroundColor(Color.init(hex: "#4ABFBB"))
                                    .aspectRatio(contentMode:.fit)
                                    .frame(width: 25, height: 25, alignment: .center)
                                    
                            }
                            .frame(width: 50, height: 50, alignment: .center)
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10))
                            
                        }
                    }
                    Spacer()
                }
                
                if (!self.selectedFood.food.image.isEmpty) {
                    VStack(alignment: .center) {
                        Spacer()
                        Button {
                            //                    guard let capturedImage = ARViewContainer().arView.session.currentFrame?.capturedImage else {
                            ////                        self.isShowingAlert = true
                            //                        return
                            //                    }
                            //                    let ciimg = CIImage(cvPixelBuffer: capturedImage)
                            //                    self.capturedImage = UIImage(ciImage: ciimg)
                            
                            self.isShowingMail = true
                        } label: {
                            Image("ShareScreen")
                                .resizable()
                                .aspectRatio(contentMode:.fit)
                                .frame(width: 66, height: 66, alignment: .center)
                        }
                    }
                }
                
            }
            .sheet(isPresented: $isFoodModalPresented) {
                
            } content: {
                FoodView(isFoodModalPresented: $isFoodModalPresented)
            }
            .sheet(isPresented: $isShowingMail) {
                MailComposeViewController(toRecipients: [], mailBody: nil, imageAttachment: nil) {
                    self.isShowingMail = false
                }
        }
        .environmentObject(selectedFood)
    }
}


//#if DEBUG
//struct ContentView_Previews : PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
//#endif
