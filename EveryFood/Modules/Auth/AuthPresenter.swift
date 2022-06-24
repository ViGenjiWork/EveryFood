//
//  AuthPresenter.swift
//  EveryFood
//
//  Created by Mikhail Zharkov on 18.06.2022.
//

import UIKit

protocol IAuthPresenter: AnyObject {
    func loadView(view: IAuthView)
    func setController(controller: IAuthViewController)
}

final class AuthPresenter {
    private weak var rootView: IAuthView?
    private weak var controller: IAuthViewController?
    private var model: [UserModel]?
    private let router: IAuthRouter
    private var networkService = AuthNetworkService()
    private let userDefaultsService = UserDefaultsService()
    
    init(router: IAuthRouter) {
        self.router = router
    }
}

extension AuthPresenter: IAuthPresenter {
    func setController(controller: IAuthViewController) {
        self.controller = controller
    }
    
    func loadView(view: IAuthView) {
        self.rootView = view
        self.rootView?.didLoad()
        self.setHandlers()
    }
    
    func setHandlers() {
        self.rootView?.didTapLoginButtonHandler = { [weak self] (email, password) in
            guard let self = self,
                  let controller = self.controller else { return }
            self.networkService.loginUser(email: email, password: password) { (result: Result<UserDTO, Error>) in
                switch result {
                case .success(let success):
                    if success.status == 1 {
                        DispatchQueue.main.sync {
                            self.userDefaultsService.set(key: .isLoggedIn, value: true)
                            let targetVC = MainAssembly.build()
                            self.router.performNavigation(from: controller, to: targetVC, routeType: .push)
                        }
                    } else {
                        DispatchQueue.main.sync {
                            let alert = UIAlertController(title: success.remarks, message: nil, preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                            alert.addAction(okAction)
                            controller.present(alert, animated: true, completion: nil)
                        }
                    }
                case .failure(let failure):
                    print(failure)
                }
            }
        }
    }
}
