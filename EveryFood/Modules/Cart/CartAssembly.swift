//
//  CartAssembly.swift
//  EveryFood
//
//  Created by Mikhail Zharkov on 15.06.2022.
//

enum CartAssembly {
    static func build() -> CartViewController {
        let router = CartRouter()
        let presenter = CartPresenter(router: router)
        let vc = CartViewController(presenter: presenter)
        return vc
    }
}
