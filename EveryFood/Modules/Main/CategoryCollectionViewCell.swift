//
//  CategoryCollectionViewCell.swift
//  EveryFood
//
//  Created by Mikhail Zharkov on 01.06.2022.
//

import UIKit

protocol ICategoryCollectionViewCell: UICollectionViewCell {
    func didLoad()
    func setData(with data: String)
}

final class CategoryCollectionViewCell: UICollectionViewCell {
    lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .sfProTextBold17
        label.textColor = .designSystemInactiveLabel
        return label
    }()
}

extension CategoryCollectionViewCell: ICategoryCollectionViewCell {
    func didLoad() {
        self.setupLayout()
    }
    
    func setData(with data: String) {
        self.categoryLabel.text = data
    }
}


private extension CategoryCollectionViewCell {
    func setupLayout() {
        self.addSubview(self.categoryLabel)
        self.categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.categoryLabel.topAnchor.constraint(equalTo: self.topAnchor),
            self.categoryLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.categoryLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.categoryLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
}
