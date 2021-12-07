//
//  FoodViewModel.swift
//  Bufet
//
//  Created by Razvan Rujoiu on 04.12.2021.
//

import Foundation

@MainActor
class FoodViewModel: ObservableObject {

    enum State {
        case not_available
        case loading
        case success
        case failed(error: Error)
    }
    @Published var foodList: [Food] = []
    @Published private(set) var state: State = .not_available
    @Published var hasError: Bool = false
    private let service: FoodService
    
    init(service: FoodService) {
        self.service = service
    }
    
    func getFoodList(sorted sortingState: SortingState) async {
        self.state = .loading
        self.hasError = false
        do {
            self.foodList = try await service.fetchFoodList()
            self.state = .success
        } catch {
            self.state = .failed(error: error)
            self.hasError = true
        }
    }
    
    
    
}
