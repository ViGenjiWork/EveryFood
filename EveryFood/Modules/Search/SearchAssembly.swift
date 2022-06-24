//
//  SearchAssembly.swift
//  EveryFood
//
//  Created by Mikhail Zharkov on 15.06.2022.
//

enum SearchAssembly {
    static func build(with data: [FoodDataDTO]) -> SearchViewController {
        let router = SearchRouter()
        let presenter = SearchPresenter(router: router, model: data)
        let vc = SearchViewController(presenter: presenter)
        return vc
    }
}
