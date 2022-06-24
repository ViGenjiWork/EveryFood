//
//  AuthRouter.swift
//  EveryFood
//
//  Created by Mikhail Zharkov on 18.06.2022.
//

import UIKit

protocol IAuthRouter {
    func performNavigation(from: UIViewController, to: UIViewController, routeType: AuthRouter.RouteType)
}

final class AuthRouter {
    enum RouteType {
        case push
        case present
    }
}

extension AuthRouter: IAuthRouter {
    func performNavigation(from currentVC: UIViewController, to targetVC: UIViewController, routeType: RouteType) {
        switch routeType {
        case .push:
            currentVC.navigationController?.pushViewController(targetVC, animated: true)
        case .present:
            currentVC.present(targetVC, animated: true, completion: nil)
        }
    }
}
