//
//  FoodView.swift
//  Bufet
//
//  Created by Razvan Rujoiu on 04.12.2021.
//

import SwiftUI

struct FoodView: View {
    
    @StateObject private var foodViewModel = FoodViewModel(service: FoodService())
    @State private var isShowingWebView: Bool = false
    @Binding var isFoodModalPresented: Bool
    
    @EnvironmentObject var selectedFood: SelectedFood
    
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    
    var body: some View {
        NavigationView {
            switch foodViewModel.state {
            case .success(let data):
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: columns) {
                        ForEach(data, id: \.id) { item in
                            FoodItem(title: item.title, details: item.details, image: item.image) {
                                print(item.title)
                                self.selectedFood.food = item
                                isFoodModalPresented = false
                            }
                        }
                    }.padding(EdgeInsets(top: 50, leading: 0, bottom: 0, trailing: 0))
                }
                .background(Image("background"))
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Bufet")
                            .font(.largeTitle.bold())
                            .accessibilityAddTraits(.isHeader)
                    }
                }
                .navigationBarItems(
                    leading:  Button(action: {
                        isFoodModalPresented = false
                    }, label: {
                        Image("002-close")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.white)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                    }),
                    trailing: Button(action: {
                        //  TODO impelent sorting
                    }, label: {
                        Image("003-sort-down")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.white)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 25)
                    })
                )
            case .loading:
                ProgressView()
            default:
                EmptyView()
            }
            
        }.task {
            await foodViewModel.getFoodList()
        }.alert("Error", isPresented: $foodViewModel.hasError, presenting: foodViewModel.state) { detail in
            Button("Retry") {
                Task {
                    await foodViewModel.getFoodList()
                }
            }
        } message: { detail in
            if case let .failed(error) = detail {
                Text(error.localizedDescription)
            }
        }.environmentObject(selectedFood)
        
    }
}



//#if DEBUG
//struct FoodView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
//#endif
