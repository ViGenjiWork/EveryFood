//
//  MainPresenter.swift
//  EveryFood
//
//  Created by Mikhail Zharkov on 31.05.2022.
//

import Foundation

protocol IMainPresenter: AnyObject {
    func setController(controller: IMainViewController)
    func loadView(view: IMainView)
    func setHandlers()
}

final class MainPresenter {
    private weak var controller: IMainViewController?
    private weak var rootView: IMainView?
    private var model: [FoodDataDTO]?
    private let router: IMainRouter
    private let networkService = FoodNetworkService()
    
    private var selectedCategory: IndexPath {
        didSet {
            guard let rootView = self.rootView else { return }
            DispatchQueue.main.async {
                rootView.deselectCategory(for: oldValue)
                rootView.selectCategory(for: self.selectedCategory)
            }
        }
    }
    
    init(router: IMainRouter) {
        self.router = router
        self.selectedCategory = [0, 0]
    }
}

extension MainPresenter: IMainPresenter {
    func setController(controller: IMainViewController) {
        self.controller = controller
    }
    
    func loadView(view: IMainView) {
        self.rootView = view
        self.rootView?.didLoad()
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.selectedCategory = [0, 0]
        }
        self.fetchDataFromNetworkService()
    }
    
    func setHandlers() {
        self.controller?.cartButtonActionHandler = { [weak self] in
            guard let self = self,
                  let controller = self.controller else { return }
            let targetVC = CartAssembly.build()
            self.router.performNavigation(from: controller, to: targetVC, routeType: .push)
        }
        
        self.controller?.profileButtonActionHandler = {
            print("navigation to profile")
        }
        
        self.rootView?.searchBarButtonActionHandler = { [weak self] in
            guard let self = self,
                  let controller = self.controller else { return }
            let targetVC = SearchAssembly.build(with: self.model ?? [])
            self.router.performNavigation(from: controller, to: targetVC, routeType: .push)
        }
        
        self.rootView?.didSelectFoodAtIndexPathHandler = { [weak self] indexPath in
            guard let self = self,
                  let controller = self.controller,
                  let data = self.model?[indexPath.row] else { return }
            let targetVC = FoodPageAssembly.build(with: data)
            self.router.performNavigation(from: controller, to: targetVC, routeType: .push)
        }
        
        self.rootView?.didSelectCategoryAtIndexPathHandler = { [weak self] indexPath in
            guard let self = self else { return }
            let category = self.filterFoodWithCategory(with: indexPath, model: self.model ?? [])
            self.selectedCategory = indexPath
            self.rootView?.updateFoodSnapshot(with: category)
        }
    }
}

private extension MainPresenter {
    func getCategories(with data: [FoodDataDTO]) -> [String] {
        var categories = data.map { $0.category }.unique()
        categories.insert("All", at: 0)
        return categories
    }
    
    func filterFoodWithCategory(with indexPath: IndexPath, model: [FoodDataDTO]) -> [FoodDataDTO] {
        let categories = self.getCategories(with: model)
        let categoryIndex = categories[indexPath.row]
        let filteredData = model.filter { $0.category == categoryIndex}
        return filteredData.count == 0 ? model : filteredData
    }
    
    func fetchDataFromNetworkService() {
        self.networkService.loadFoodData { (result: Result<FoodDTO, Error>) in
            switch result {
            case .success(let success):
                DispatchQueue.main.async {
                    self.model = success.data
                    self.rootView?.updateFoodSnapshot(with: success.data)
                    self.rootView?.updateCategoriesSnapshot(with: self.getCategories(with: success.data))
                }
            case .failure(let failure):
                print(failure)
            }
        }
    }
}

