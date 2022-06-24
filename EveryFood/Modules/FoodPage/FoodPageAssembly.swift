//
//  FoodPageAssembly.swift
//  EveryFood
//
//  Created by Mikhail Zharkov on 03.06.2022.
//

enum FoodPageAssembly {
    static func build(with data: FoodDataDTO) -> FoodPageViewController {
        let router = FoodPageRouter()
        let presenter = FoodPagePresenter(router: router, model: data)
        let vc = FoodPageViewController(presenter: presenter)
        return vc
    }
}


