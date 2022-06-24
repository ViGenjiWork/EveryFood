//
//  MainRouter.swift
//  EveryFood
//
//  Created by Mikhail Zharkov on 31.05.2022.
//

import UIKit

protocol IMainRouter: AnyObject {
    func performNavigation(from: UIViewController, to: UIViewController, routeType: MainRouter.RouteType)
}

final class MainRouter {
    enum RouteType {
        case push
        case present
    }
}

extension MainRouter: IMainRouter {
    func performNavigation(from currentVC: UIViewController, to targetVC: UIViewController, routeType: RouteType) {
        switch routeType {
        case .push:
            currentVC.navigationController?.pushViewController(targetVC, animated: true)
        case .present:
            currentVC.present(targetVC, animated: true, completion: nil)
        }
    }
}
