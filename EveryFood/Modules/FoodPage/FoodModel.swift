//
//  FoodModel.swift
//  EveryFood
//
//  Created by Mikhail Zharkov on 23.06.2022.
//

import Foundation

class FoodModel {
    let id: String?
    let title: String?
    let price: Int16?
    let image: String?
    
    init(coreDataModel: CartEntity) {
        self.id = coreDataModel.id
        self.title = coreDataModel.title
        self.price = coreDataModel.price
        self.image = coreDataModel.image
    }
}
