//
//  CartViewController.swift
//  EveryFood
//
//  Created by Mikhail Zharkov on 15.06.2022.
//

import UIKit

protocol ICartViewController: UIViewController {
    
}

final class CartViewController: UIViewController {
    private let rootView: ICartView
    private let presenter: ICartPresenter
    
    init(presenter: ICartPresenter) {
        self.presenter = presenter
        self.rootView = CartView()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.title = "Cart"
        self.view = self.rootView
        self.presenter.loadView(view: self.rootView)
    }
}

extension CartViewController: ICartViewController {
    
}
