//
//  TextFieldBuilder.swift
//  EveryFood
//
//  Created by Mikhail Zharkov on 18.06.2022.
//

import UIKit

class TextFieldBuilder {
    
    private var isTitleExist: Bool = true
    private let view = UIView(frame: .zero)
    
    private lazy var underlinedTextField: UnderlinedTextField = {
        let textField = UnderlinedTextField(font: nil)
        return textField
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .designSystemInactiveLabel
        label.font = .sfProTextBold15
        return label
    }()
    
    func withTitle(title: String) -> TextFieldBuilder {
        self.isTitleExist = true
        self.titleLabel.text = title
        return self
    }
    
    func setKeyboardType(type: UIKeyboardType) -> TextFieldBuilder {
        self.underlinedTextField.keyboardType = type
        return self
    }
    
    func withPlaceholder(placeholder: String) -> TextFieldBuilder {
        self.underlinedTextField.placeholder = placeholder
        return self
    }
    
    func build() -> UIView {
        return self.view
    }
    
    init() {
        if isTitleExist == false {
            self.setupViewWithoutTitle()
        } else {
            self.setupViewWithTitle()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension TextFieldBuilder {
    func setupViewWithoutTitle() {
        self.view.addSubview(self.underlinedTextField)
        self.underlinedTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.underlinedTextField.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.underlinedTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.underlinedTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.underlinedTextField.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    func setupViewWithTitle() {
        self.view.addSubview(self.titleLabel)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.titleLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
        
        self.view.addSubview(self.underlinedTextField)
        self.underlinedTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.underlinedTextField.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor),
            self.underlinedTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.underlinedTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.underlinedTextField.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
}
