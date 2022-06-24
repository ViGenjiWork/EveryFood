//
//  SearchPresenter.swift
//  EveryFood
//
//  Created by Mikhail Zharkov on 15.06.2022.
//

protocol ISearchPresenter: AnyObject {
    func setController(controller: ISearchViewController)
    func loadView(view: ISearchView)
    func setHandlers()
}

final class SearchPresenter {
    private weak var controller: ISearchViewController?
    private weak var rootView: ISearchView?
    private var models: [FoodDataDTO]
    private let router: ISearchRouter
    
    init(router: ISearchRouter, model: [FoodDataDTO]) {
        self.router = router
        self.models = model
    }
}

extension SearchPresenter: ISearchPresenter {
    func setController(controller: ISearchViewController) {
        self.controller = controller
    }
    
    func loadView(view: ISearchView) {
        self.rootView = view
        self.rootView?.didLoad()
        self.rootView?.updateFoodSnapshot(with: self.models)
    }
    
    func setHandlers() {
        self.rootView?.didSelectFoodAtIndexPathHandler = { [weak self] indexPath in
            guard let self = self,
                  let controller = self.controller else { return }
            let data = self.models[indexPath.row]
            let targetVC = FoodPageAssembly.build(with: data)
            self.router.performNavigation(from: controller, to: targetVC, routeType: .push)
        }
        
        self.rootView?.searchBarView.searchBarHandler = { [weak self] text in
            guard let self = self else { return }
            self.reloadData(with: text)
        }
        
        self.rootView?.searchBarView.searchBarCancelButtonHandler = { [weak self] in
            guard let self = self else { return }
            self.rootView?.updateFoodSnapshot(with: self.models)
        }
    }
}

private extension SearchPresenter {
    func contains(entity: FoodDataDTO, filter: String?) -> Bool {
        guard let filter = filter else { return true }
        if filter.isEmpty { return true }
        let lowerCasedFilter = filter.lowercased()
        return entity.title.lowercased().contains(lowerCasedFilter)
    }
    
    func reloadData(with searchText: String?) {
        let filtered = models.filter { (food) -> Bool in
            self.contains(entity: food, filter: searchText)
        }
        self.rootView?.updateFoodSnapshot(with: filtered)
    }
}
