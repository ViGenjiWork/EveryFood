//
//  FoodPageCollectionViewCell.swift
//  EveryFood
//
//  Created by Mikhail Zharkov on 03.06.2022.
//

import UIKit

protocol IFoodPageCollectionViewCell: UICollectionViewCell {
    func didLoad()
}

final class FoodPageCollectionViewCell: UICollectionViewCell {
    
    private enum Metrics {
        static let foodImageViewCornerRaius: CGFloat = 24
    }
    
    var imageData: Data? {
        didSet {
            if let data = self.imageData {
                self.foodImageView.image = UIImage(data: data)
            }
        }
    }
    
    private lazy var foodImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Metrics.foodImageViewCornerRaius
        return imageView
    }()
}

extension FoodPageCollectionViewCell: IFoodPageCollectionViewCell {
    func didLoad() {
        self.setupLayout()
    }
}

private extension FoodPageCollectionViewCell {
    func setupLayout() {
        self.backgroundColor = .clear
        
        self.addSubview(self.foodImageView)
        self.foodImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.foodImageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            self.foodImageView.widthAnchor.constraint(equalToConstant: self.bounds.width * 0.7),
            self.foodImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.foodImageView.heightAnchor.constraint(equalToConstant: self.bounds.width * 0.7)
        ])
    }
}
