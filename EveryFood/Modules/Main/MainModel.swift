//
//  MainModel.swift
//  EveryFood
//
//  Created by Mikhail Zharkov on 31.05.2022.
//

struct MainModel: Hashable {
    let id: String
    let images: [String]
    let title: String
    let category: String
    let description: String
    let compound: String
    let price: Int
}

