//
//  SearchViewController.swift
//  EveryFood
//
//  Created by Mikhail Zharkov on 15.06.2022.
//

import UIKit

protocol ISearchViewController: UIViewController {
    
}

final class SearchViewController: UIViewController {
    private let rootView: ISearchView
    private let presenter: ISearchPresenter
    
    init(presenter: ISearchPresenter) {
        self.presenter = presenter
        self.rootView = SearchView()
        super.init(nibName: nil, bundle: nil)
        self.presenter.setController(controller: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = self.rootView
        self.setupNavBar()
        self.presenter.loadView(view: self.rootView)
        self.presenter.setHandlers()
    }
}

extension SearchViewController: ISearchViewController {
    
}

private extension SearchViewController {
    func setupNavBar() {
        lazy var searchBar = self.rootView.searchBarView
        
        self.navigationController?.navigationBar.tintColor = .darkGray
        self.navigationItem.titleView = searchBar
        self.navigationItem.backButtonDisplayMode = .minimal
    }
}
