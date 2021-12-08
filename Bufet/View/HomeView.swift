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
            ZStack {
                
                ARViewContainer().edgesIgnoringSafeArea(.all)
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
                
                if (!self.selectedFood.food.image.isEmpty) {
                    VStack(alignment: .center) {
                        Spacer()
                        Button {
                            arView.snapshot(saveToHDR: false) { image in
                                let image = UIImage(data: (image?.pngData())!)
                                capturedImage = image!
                                self.isShowingMail = true
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
            .sheet(isPresented: $isFoodModalPresented) {
                
            } content: {
                FoodView(isFoodModalPresented: $isFoodModalPresented)
            }
            .sheet(isPresented: $isShowingMail) {
                MailComposeViewController(toRecipients: [], mailBody: nil, imageAttachment: capturedImage) {
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
