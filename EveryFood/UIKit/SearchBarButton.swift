//
//  SearchBarButton.swift
//  EveryFood
//
//  Created by Mikhail Zharkov on 01.06.2022.
//

import UIKit

final class Button: UIView {
    struct Settings {
        let title: String
        let tapHandler: () -> Void
    }
    
    private enum Metrics {
        static let cornerRadius: CGFloat = 30
    }
    
    private var tapHandler: () -> Void
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .sfProTextBold17
        label.textColor = .white
        return label
    }()
    
    init(with settings: Settings) {
        self.tapHandler = settings.tapHandler
        super.init(frame: .zero)
        self.titleLabel.text = settings.title
        self.configureView()
        self.setupLayout()
        self.addAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension Button {
    func configureView() {
        self.backgroundColor = .designSystemOrange
        self.layer.cornerRadius = Metrics.cornerRadius
        self.layer.masksToBounds = true
    }
}

private extension Button {
    func setupLayout() {
        self.addSubview(self.titleLabel)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
}

// MARK: - Добавляем настройки
private extension Button {
    func addAction() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.viewTapped))
        self.addGestureRecognizer(gestureRecognizer)
    }

    @objc func viewTapped() {
        self.tapHandler()
    }
}
