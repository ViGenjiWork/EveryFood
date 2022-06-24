//
//  TitleSupplementaryView.swift
//  EveryFood
//
//  Created by Mikhail Zharkov on 15.06.2022.
//

import UIKit

final class TitleSupplementaryView: UICollectionReusableView {
    enum Metrics {
        static let labelTopOffset: CGFloat = 15
        static let labelBottomOffset: CGFloat = 30
    }
    
    static let reuseIdentifier = "title-supplementary-reuse-identifier"
    
    var titleLabelText: String? {
        didSet {
            self.titleLabel.text = self.titleLabelText
        }
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .sfProTextBold28
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension TitleSupplementaryView {
    func configure() {
        self.addSubview(self.titleLabel)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.adjustsFontForContentSizeCategory = true
        NSLayoutConstraint.activate([
            self.titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            self.titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            self.titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: Metrics.labelTopOffset),
            self.titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Metrics.labelBottomOffset)
        ])
    }
}

