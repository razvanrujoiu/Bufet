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
//    @StateObject private var selectedFood: Food
    
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
                            }
                        }
                    }.padding(EdgeInsets(top: 50, leading: 0, bottom: 0, trailing: 0))
                }
                .background(Image(uiImage: UIImage(named: "background")!))
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
                        Image(systemName: "xmark")
                            .foregroundColor(Color.white)
                            .font(Font.headline.weight(.bold))
                    }),
                    trailing: Button(action: {
                        //  TODO impelent sorting
                    }, label: {
                        Image(systemName: "arrow.up.arrow.down")
                            .foregroundColor(Color.white)
                            .font(Font.headline.weight(.bold))
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
        }
        
    }
}



#if DEBUG
struct FoodView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
