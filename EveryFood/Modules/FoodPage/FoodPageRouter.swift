//
//  FoodPageRouter.swift
//  EveryFood
//
//  Created by Mikhail Zharkov on 03.06.2022.
//

import UIKit

protocol IFoodPageRouter {
    func performNavigation(from: UIViewController, to: UIViewController, routeType: FoodPageRouter.RouteType)
    func goBack(from currentVC: UIViewController)
}

final class FoodPageRouter {
    enum RouteType {
        case push
        case present
    }
}

extension FoodPageRouter: IFoodPageRouter {
    func performNavigation(from currentVC: UIViewController, to targetVC: UIViewController, routeType: RouteType) {
        switch routeType {
        case .push:
            currentVC.navigationController?.pushViewController(targetVC, animated: true)
        case .present:
            currentVC.present(targetVC, animated: true, completion: nil)
        }
    }
    
    func goBack(from currentVC: UIViewController) {
        currentVC.navigationController?.popToRootViewController(animated: true)
    }
}

