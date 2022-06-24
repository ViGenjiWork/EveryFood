//
//  FoodPagePresenter.swift
//  EveryFood
//
//  Created by Mikhail Zharkov on 03.06.2022.
//

import CoreData

protocol IFoodPagePresenter: AnyObject {
    func setController(controller: IFoodPageViewController)
    func loadView(view: IFoodPageView)
    func setHandlers()
}

final class FoodPagePresenter {
    private weak var controller: IFoodPageViewController?
    private weak var rootView: IFoodPageView?
    private let router: IFoodPageRouter
    private let model: FoodDataDTO
    private let networkService = FoodNetworkService()
    private let coreDataService = CoreDataManager()
    
    init(router: IFoodPageRouter, model: FoodDataDTO) {
        self.router = router
        self.model = model
    }
}

extension FoodPagePresenter: IFoodPagePresenter {
    func setController(controller: IFoodPageViewController) {
        self.controller = controller
    }
    
    func loadView(view: IFoodPageView) {
        self.rootView = view
        self.rootView?.didLoad()
        self.rootView?.setData(with: self.model)
        self.rootView?.updateCarouselSnapshot(with: self.model.images)
        self.setHandlers()
    }
    
    func setHandlers() {
        self.rootView?.addToCartActionHandler = { [weak self] in
            guard let self = self else { return }
            self.coreDataService.addToCart(cartItem: self.model)
            self.router.goBack(from: self.controller!)
        }
    }
}
