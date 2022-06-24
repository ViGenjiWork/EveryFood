//
//  CartRouter.swift
//  EveryFood
//
//  Created by Mikhail Zharkov on 15.06.2022.
//

import UIKit

protocol ICartRouter {
    func performNavigation(from: UIViewController, to: UIViewController, routeType: CartRouter.RouteType)
}

final class CartRouter {
    enum RouteType {
        case push
        case present
    }
}

extension CartRouter: ICartRouter {
    func performNavigation(from currentVC: UIViewController, to targetVC: UIViewController, routeType: RouteType) {
        switch routeType {
        case .push:
            currentVC.navigationController?.pushViewController(targetVC, animated: true)
        case .present:
            currentVC.present(targetVC, animated: true, completion: nil)
        }
    }
}
