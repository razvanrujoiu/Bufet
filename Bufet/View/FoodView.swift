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
    @State private var isShowingWebView: Bool = false
    @EnvironmentObject var selectedFood: SelectedFood
    @State private var sortingState: SortingState = .descending
    
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
                        switch sortingState {
                        case .none:
                            sortingState = .ascending
                        case .ascending:
                            sortingState = .descending
                        case .descending:
                            sortingState = .none
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



//#if DEBUG
//struct FoodView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
//#endif
