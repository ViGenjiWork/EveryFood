//
//  CartPresenter.swift
//  EveryFood
//
//  Created by Mikhail Zharkov on 15.06.2022.
//

import Foundation

protocol ICartPresenter: AnyObject {
    func setController(controller: ICartViewController)
    func loadView(view: ICartView)
    func setHandlers()
}

final class CartPresenter {
    private weak var controller: ICartViewController?
    private weak var rootView: ICartView?
    private var models: [FoodModel]?
    private let router: ICartRouter
    private let coreDataManager = CoreDataManager()
    private let cartDelegate = CartDelegate()
    
    
    init(router: ICartRouter) {
        self.router = router
    }
}

extension CartPresenter: ICartPresenter {
    func setController(controller: ICartViewController) {
        self.controller = controller
    }
    
    func loadView(view: ICartView) {
        self.rootView = view
        self.rootView?.didLoad()
        self.loadData()
        self.rootView?.setData(with: self.models ?? [])
        self.setHandlers()
    }
    
    func setHandlers() {
        self.rootView?.didDeleteItemAtIndexPathHandler = { [weak self] indexPath in
            guard let self = self else { return }
            self.coreDataManager.removeCartItem(cartItem: self.models![indexPath.section])
            self.models?.remove(at: indexPath.section)
            self.rootView?.setData(with: self.models ?? [])
        }
    }
}

private extension CartPresenter {
    func loadData() {
        self.coreDataManager.loadCartItems { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.models = data
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
