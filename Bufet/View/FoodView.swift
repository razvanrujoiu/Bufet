//
//  FoodView.swift
//  Bufet
//
//  Created by Razvan Rujoiu on 04.12.2021.
//

import SwiftUI


struct FoodView: View {
    
    @Binding var isFoodModalPresented: Bool
    @StateObject private var foodViewModel = FoodViewModel(service: FoodService())
    @EnvironmentObject var selectedFood: SelectedFood
    @State private var isShowingWebView: Bool = false
    @State private var sortingState: SortingState = .none
    
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    
    var body: some View {
        NavigationView {
            switch foodViewModel.state {
            case .success:
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: columns) {
                        ForEach(foodViewModel.foodList, id: \.id) { item in
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
                            .foregroundColor(.white)
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
                        switch sortingState {
                        case .none:
                            sortingState = .ascending
                            foodViewModel.foodList.sort(by: { $0.title.lowercased() < $1.title.lowercased() })
                        case .ascending:
                            sortingState = .descending
                            foodViewModel.foodList.sort(by: { $0.title.lowercased() > $1.title.lowercased() })
                        case .descending:
                            sortingState = .none
                            foodViewModel.foodList.sort(by: { $0.id < $1.id })
                        }
                    }, label: {
                        switch sortingState {
                        case .none:
                            sortIcon(.white)
                        case .ascending:
                            sortIcon(.black)
                        case .descending:
                            sortIcon(.red)
                        }
                    })
                )
            case .loading:
                ProgressView()
            default:
                EmptyView()
            }
            
        }.task {
            await foodViewModel.getFoodList(sorted: sortingState)
        }.alert("Error", isPresented: $foodViewModel.hasError, presenting: foodViewModel.state) { detail in
            Button("Retry") {
                Task {
                    await foodViewModel.getFoodList(sorted: .none)
                }
            }
        } message: { detail in
            if case let .failed(error) = detail {
                Text(error.localizedDescription)
            }
        }.environmentObject(selectedFood)
        
    }
    
    private func sortIcon(_ color: Color) -> some View {
        Image("003-sort-down")
            .resizable()
            .renderingMode(.template)
            .foregroundColor(color)
            .aspectRatio(contentMode: .fit)
            .frame(width: 25, height: 25)
    }
   
}
