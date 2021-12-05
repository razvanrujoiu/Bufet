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
    @State private var capturedImage: UIImage = UIImage()
    
    @StateObject var selectedFood: SelectedFood = SelectedFood()
    
    var body: some View {
//        NavigationView {
            ZStack {
                ARViewContainer().edgesIgnoringSafeArea(.all)
                VStack(alignment: .trailing) {
                    HStack {
                        Spacer()
                        Button {
                            isFoodModalPresented = true
                        } label: {
                            Image(uiImage: UIImage(named: "burger")!)
                                .resizable()
                                .aspectRatio(contentMode:.fit)
                                .frame(width: 44, height: 44, alignment: .center)
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
                            Image(uiImage: UIImage(named: "telegram")!)
                                .resizable()
                                .aspectRatio(contentMode:.fit)
                                .frame(width: 66, height: 66, alignment: .center)
                        }
                        //                .alert("Current frame is null", isPresented: $isShowingAlert) {
                        //                    Button("OK", role: .cancel) {}
                        //                }
                    }
                }
                
            }
            .sheet(isPresented: $isFoodModalPresented) {
                
            } content: {
                FoodView(isFoodModalPresented: $isFoodModalPresented)
            }
            .sheet(isPresented: $isShowingMail) {
                MailComposeViewController(toRecipients: [], mailBody: nil, imageAttachment: self.capturedImage) {
                    self.isShowingMail = false
                }
//            }
        }.environmentObject(selectedFood)
    }
}


//#if DEBUG
//struct ContentView_Previews : PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
//#endif
