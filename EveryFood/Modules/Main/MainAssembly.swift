//
//  MainAssembly.swift
//  EveryFood
//
//  Created by Mikhail Zharkov on 31.05.2022.
//

enum MainAssembly {
    static func build() -> MainViewController {
        let router = MainRouter()
        let presenter = MainPresenter(router: router)
        let vc = MainViewController(presenter: presenter)
        return vc
    }
}
