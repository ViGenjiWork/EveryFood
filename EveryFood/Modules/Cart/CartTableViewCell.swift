//
//  CartTableViewCell.swift
//  EveryFood
//
//  Created by Mikhail Zharkov on 15.06.2022.
//

import UIKit

protocol ICartTableViewCell: UITableViewCell {
    func didLoad()
    func setData(with data: FoodModel)
    
    var imageData: Data? { get set }
}

final class CartTableViewCell: UITableViewCell {
    private enum Metrics {
        static let foodImageSize: CGFloat = 80
    }
    
    static let identifier = "CartProduct"
    
    var imageData: Data? {
        didSet {
            if let data = self.imageData {
                self.foodImage.image = UIImage(data: data)
            }
        }
    }
    
    private lazy var customContentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        return view
    }()
    
    private lazy var foodTitle: UILabel = {
        let label = UILabel()
        label.font = .sfProTextBold17
        return label
    }()
    
    private lazy var foodImage: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var foodPrice: UILabel = {
        let label = UILabel()
        label.font = .sfProTextBold17
        label.textColor = .designSystemOrange
        return label
    }()
}

extension CartTableViewCell: ICartTableViewCell {
    func didLoad() {
        self.backgroundColor = .designSystemMainBG
        self.setupLayout()
    }
    
    func setData(with data: FoodModel) {
        self.foodTitle.text = data.title
        self.foodImage.image = UIImage(named: data.image ?? "food")
        self.foodPrice.text = "\(Int16(data.price ?? 0)) ₽"
    }
}

private extension CartTableViewCell {
    func setupLayout() {
        self.addSubview(self.customContentView)
        self.customContentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.customContentView.topAnchor.constraint(equalTo: self.topAnchor),
            self.customContentView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 50),
            self.customContentView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -50),
            self.customContentView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
        
        self.customContentView.addSubview(self.foodImage)
        self.foodImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.foodImage.heightAnchor.constraint(equalToConstant: Metrics.foodImageSize),
            self.foodImage.widthAnchor.constraint(equalToConstant: Metrics.foodImageSize),
            self.foodImage.leadingAnchor.constraint(equalTo: self.customContentView.leadingAnchor, constant: 10),
            self.foodImage.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        self.customContentView.addSubview(self.foodTitle)
        self.foodTitle.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.foodTitle.topAnchor.constraint(equalTo: self.customContentView.topAnchor, constant: 25),
//            self.foodTitle.bottomAnchor.constraint(equalTo: self.customContentView.bottomAnchor, constant: -10),
            self.foodTitle.leadingAnchor.constraint(equalTo: self.foodImage.trailingAnchor, constant: 15),
            self.foodTitle.trailingAnchor.constraint(equalTo: self.customContentView.trailingAnchor),
        ])
        
        self.customContentView.addSubview(self.foodPrice)
        self.foodPrice.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
//            self.foodPrice.topAnchor.constraint(equalTo: self.customContentView.topAnchor, constant: 25),
            self.foodPrice.bottomAnchor.constraint(equalTo: self.customContentView.bottomAnchor, constant: -25),
            self.foodPrice.leadingAnchor.constraint(equalTo: self.foodImage.trailingAnchor, constant: 15),
            self.foodPrice.trailingAnchor.constraint(equalTo: self.customContentView.trailingAnchor),
        ])
        
    }
}
