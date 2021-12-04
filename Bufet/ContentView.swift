//
//  ContentView.swift
//  Bufet
//
//  Created by Razvan Rujoiu on 04.12.2021.
//

import SwiftUI
import RealityKit

struct ContentView : View {
    
    @StateObject private var foodViewModel = FoodViewModel(service: FoodService())
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    
    var body: some View {
        NavigationView {
            switch foodViewModel.state {
            case .success(let data):
                ScrollView {
                    LazyVGrid(columns: columns) {
                        ForEach(data, id: \.id) { item in
                            ZStack {
                                Text(item.title)
                                    .font(.system(size: 22, weight: .bold))
                                    .foregroundColor(Color.black)
                                    .padding(EdgeInsets(top: 0, leading: 0, bottom: -20, trailing: 0))
                                    .frame(width: 170, height: 65, alignment: .center)
                                    .background(RoundedRectangle(cornerRadius: 10))
                                
                                AsyncImage(url: URL(string: item.image)!, placeholder: {Color.gray}, image: { image in
                                    Image(uiImage: image).resizable()
                                }).aspectRatio(contentMode: .fit)
                                    .frame(width: 100, height: 100, alignment: .center)
                                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 110, trailing: 0))
                            }.frame(width: 170, height: 150)
                            
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
                        //  TODO impelent close
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
        
        //        return ARViewContainer().edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)
        
        
        // Load the "Box" scene from the "Experience" Reality File
        //        let boxAnchor = try! Experience.loadBox()
        
        // Add the box anchor to the scene
        //        arView.scene.anchors.append(boxAnchor)
        
        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
