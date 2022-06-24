//
//  AuthAssembly.swift
//  EveryFood
//
//  Created by Mikhail Zharkov on 18.06.2022.
//

enum AuthAssembly {
    static func build() -> AuthViewController {
        let router = AuthRouter()
        let presenter = AuthPresenter(router: router)
        let vc = AuthViewController(presenter: presenter)
        return vc
    }
}

