//
//  MainViewController.swift
//  EveryFood
//
//  Created by Mikhail Zharkov on 31.05.2022.
//

import UIKit

protocol IMainViewController: UIViewController {
    var cartButtonActionHandler: (() -> Void)? { get set }
    var profileButtonActionHandler: (() -> Void)? { get set }
}

final class MainViewController: UIViewController {
    private let presenter: IMainPresenter
    private let rootView: IMainView
    
    var cartButtonActionHandler: (() -> Void)?
    var profileButtonActionHandler: (() -> Void)?
    
    init(presenter: IMainPresenter) {
        self.presenter = presenter
        self.rootView = MainView()
        super.init(nibName: nil, bundle: nil)
        self.presenter.setController(controller: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = rootView
        self.setupNavBar()
        self.presenter.loadView(view: self.rootView)
        self.presenter.setHandlers()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension MainViewController: IMainViewController {
    
}

private extension MainViewController {
    @objc func cartButtonAction() {
        self.cartButtonActionHandler?()
    }
    
    @objc func profileButtonAction() {
        self.profileButtonActionHandler?()
    }
}

private extension MainViewController {
    func setupNavBar() {
        self.navigationController?.navigationBar.tintColor = .darkGray
        let cart = UIBarButtonItem(image: UIImage(named: "cart-icon"),
                                   style: .plain,
                                   target: self,
                                   action: #selector(self.cartButtonAction))
        cart.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        let profile = UIBarButtonItem(image: UIImage(named: "user-icon"),
                                      style: .plain,
                                      target: self,
                                      action: #selector(self.profileButtonAction))
        profile.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        self.navigationItem.leftBarButtonItem = profile
        self.navigationItem.rightBarButtonItem = cart
        self.navigationItem.backButtonDisplayMode = .minimal
    }
}
