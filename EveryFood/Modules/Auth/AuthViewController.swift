//
//  AuthViewController.swift
//  EveryFood
//
//  Created by Mikhail Zharkov on 18.06.2022.
//

import UIKit

protocol IAuthViewController: UIViewController {
    
}

final class AuthViewController: UIViewController {
    private let rootView: IAuthView
    private let presenter: IAuthPresenter
    
    init(presenter: IAuthPresenter) {
        self.presenter = presenter
        self.rootView = AuthView()
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
}

extension AuthViewController: IAuthViewController {

}
