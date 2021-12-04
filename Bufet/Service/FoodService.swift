//
//  FoodService.swift
//  Bufet
//
//  Created by Razvan Rujoiu on 04.12.2021.
//

import Foundation

struct FoodService {
    
    enum FoodServiceError: Error {
        case failed
        case failedToDecode
        case invalidStatusCode
    }
    
    func fetchFoodList() async throws -> [Food] {
        let url = URL(string: "https://food-api-test.herokuapp.com/food_items")!
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse,
              response.statusCode == 200 else {
                  throw FoodServiceError.invalidStatusCode
              }
        let decodedData = try JSONDecoder().decode([Food].self, from: data)
        return decodedData
    }
}
