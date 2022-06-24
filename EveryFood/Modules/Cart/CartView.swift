//
//  CartView.swift
//  EveryFood
//
//  Created by Mikhail Zharkov on 15.06.2022.
//

import UIKit

protocol ICartView: UIView {
    func didLoad()
    func setData(with data: [FoodModel])
    
    var didDeleteItemAtIndexPathHandler: ((IndexPath) ->())? { get set }
}

final class CartView: UIView {
    private enum Metrics {
        
    }
    
    private var cartDataSource = CartDataSource()
    private var cartDelegate = CartDelegate()
    
    var didDeleteItemAtIndexPathHandler: ((IndexPath) -> ())? {
        didSet {
            self.cartDelegate.didDeleteItemAtIndexPathHandler = self.didDeleteItemAtIndexPathHandler
        }
    }
    
    private lazy var cartTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .designSystemMainBG
        tableView.dataSource = self.cartDataSource
        tableView.delegate = self.cartDelegate
        tableView.register(CartTableViewCell.self,
                           forCellReuseIdentifier: CartTableViewCell.identifier)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private lazy var completeOrderButton = Button(with: .init(title: "Complete order", tapHandler: {
        print("Order completed")
    }))
}

extension CartView: ICartView {
    func setData(with data: [FoodModel]) {
        self.cartDataSource.data = data
    }
    
    func didLoad() {
        self.setupUI()
        self.setupCartTableView()
    }
}

private extension CartView {
    func setupUI() {
        self.backgroundColor = .designSystemMainBG
        self.setupCartTableView()
        self.setupCompleteButton()
    }
    
    func setupCartTableView() {
        self.addSubview(self.cartTableView)
        self.cartTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.cartTableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10),
            self.cartTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.cartTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.cartTableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -90)
        ])
    }
    
    func setupCompleteButton() {
        self.addSubview(self.completeOrderButton)
        self.completeOrderButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.completeOrderButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            self.completeOrderButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            self.completeOrderButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30),
            self.completeOrderButton.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
}
