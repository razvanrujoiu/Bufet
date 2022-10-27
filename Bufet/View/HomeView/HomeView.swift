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
    @StateObject var capturedImage: CapturedImage = CapturedImage()
    
    var body: some View {
            ZStack {
                ARViewContainer().edgesIgnoringSafeArea(.all)
                MenuButton(isFoodModalPresented: $isFoodModalPresented)
                if (!self.selectedFood.food.image.isEmpty) {
                    SendButton(isShowingMail: $isShowingMail)
                        .environmentObject(capturedImage)
                }
            }

            .sheet(isPresented: $isFoodModalPresented) {

            } content: {
                FoodView(isFoodModalPresented: $isFoodModalPresented)
            }
            .sheet(isPresented: $isShowingMail) {
                MailComposeViewController(toRecipients: [], mailBody: nil) {
                    self.isShowingMail = false
            }
        }
        .environmentObject(selectedFood)
        .environmentObject(capturedImage)
    }

}
