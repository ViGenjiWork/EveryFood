//
//  AppNavigationController.swift
//  EveryFood
//
//  Created by Mikhail Zharkov on 01.06.2022.
//

import UIKit

final class AppNavigationController: UINavigationController {
    private let userDefaultsService = UserDefaultsService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavBar()
        self.appointView()
    }
}

private extension AppNavigationController {
    func setupNavBar() {

    }
    
    func appointView() {
        let isLoggedIn: Bool? = self.userDefaultsService.get(key: .isLoggedIn)
        if isLoggedIn == true {
            let baseVC = MainAssembly.build()
            self.setViewControllers([baseVC], animated: true)
        } else {
            let authVC = AuthAssembly.build()
            self.setViewControllers([authVC], animated: true)
        }
    }
}
