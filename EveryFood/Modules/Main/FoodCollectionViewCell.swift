//
//  FoodCollectionViewCell.swift
//  EveryFood
//
//  Created by Mikhail Zharkov on 01.06.2022.
//

import UIKit

protocol IFoodCollectionViewCell: UICollectionViewCell {
    func didLoad()
    func setData(with data: FoodDataDTO)
}

final class FoodCollectionViewCell: UICollectionViewCell {
    private enum Metrics {
        static let customContentViewTopOffset: CGFloat = 50
        static let customContentViewCornerRadius: CGFloat = 15
    }
    
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
        view.layer.cornerRadius = Metrics.customContentViewCornerRadius
        view.layer.shadowOffset = CGSize(width: 2, height: 2)
        view.layer.shadowRadius = 5
        view.layer.shadowOpacity = 0.3
//        view.layer.shadowPath = UIBezierPath(rect: view.bounds).cgPath
        return view
    }()
    
    private lazy var foodImage: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var foodTitle: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = .sfProTextBold22
        return label
    }()
    
    private lazy var foodPrice: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.font = .sfProTextBold17
        label.textColor = .designSystemOrange
        return label
    }()
}

extension FoodCollectionViewCell: IFoodCollectionViewCell {
    func didLoad() {
        self.setupUI()
    }
    
    func setData(with data: FoodDataDTO) {
        self.foodTitle.text = data.title
        self.foodPrice.text = "\(data.price) ₽"
    }
}

private extension FoodCollectionViewCell {
    func setupUI() {
        self.addSubview(self.customContentView)
        self.customContentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.customContentView.topAnchor.constraint(equalTo: self.topAnchor, constant: self.bounds.width * 0.4),
            self.customContentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.customContentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.customContentView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
        
        self.addSubview(self.foodImage)
        self.foodImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.foodImage.topAnchor.constraint(equalTo: self.topAnchor),
            self.foodImage.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.foodImage.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8),
            self.foodImage.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8)
        ])
        
        self.addSubview(self.foodTitle)
        self.foodTitle.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.foodTitle.topAnchor.constraint(equalTo: self.foodImage.bottomAnchor),
            self.foodTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            self.foodTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
        ])
        
        self.addSubview(self.foodPrice)
        self.foodPrice.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.foodPrice.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            self.foodPrice.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            self.foodPrice.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            self.foodPrice.heightAnchor.constraint(equalToConstant: 25)
        ])
        
    }
}
