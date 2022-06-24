//
//  FoodDTO.swift
//  EveryFood
//
//  Created by Mikhail Zharkov on 22.06.2022.
//

import Foundation

struct FoodDTO: Codable {
    let status: Int
    let remarks: String
    let data: [FoodDataDTO]
}

// MARK: - Datum
struct FoodDataDTO: Codable, Hashable {
    let id: String
    let images: [String]
    let title, category, description, compound: String
    let price: Int

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case images, title, category
        case description = "description"
        case compound, price
    }
}
