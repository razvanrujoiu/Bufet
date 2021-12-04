//
//  Food.swift
//  Bufet
//
//  Created by Razvan Rujoiu on 04.12.2021.
//

import Foundation

fileprivate struct RawServerFoodResponse: Decodable {
    let id: Int
    let title: String
    let image: image
    let details_url: String
    
    struct image: Decodable {
        let url: String
    }
}

struct Food: Codable, Identifiable {
    let id: Int
    let title: String
    let image: String
    let details: String
    
    init(from decoder: Decoder) throws {
        let rawResponse = try RawServerFoodResponse(from: decoder)
        id = rawResponse.id
        title = rawResponse.title
        image = rawResponse.image.url
        details = rawResponse.details_url
    }
}
