//
//  FoodPageViewController.swift
//  EveryFood
//
//  Created by Mikhail Zharkov on 03.06.2022.
//

import UIKit

protocol IFoodPageViewController: UIViewController {
    
}

final class FoodPageViewController: UIViewController {
    private let rootView: IFoodPageView
    private let presenter: IFoodPagePresenter
    
    init(presenter: IFoodPagePresenter) {
        self.presenter = presenter
        self.rootView = FoodPageView()
        super.init(nibName: nil, bundle: nil)
        self.presenter.setController(controller: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = self.rootView
        self.presenter.loadView(view: self.rootView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension FoodPageViewController: IFoodPageViewController {

}

