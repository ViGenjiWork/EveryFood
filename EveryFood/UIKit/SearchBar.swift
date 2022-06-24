//
//  SearchBar.swift
//  EveryFood
//
//  Created by Mikhail Zharkov on 16.06.2022.
//

import UIKit

protocol INavigationSearchBar {
    var searchBarHandler: ((String) -> Void)? { get set }
    var searchBarCancelButtonHandler: (() -> Void)? { get set }
}

final class NavigationSearchBar: UIView {
    
    var searchBarHandler: ((String) -> Void)?
    var searchBarCancelButtonHandler: (() -> Void)?
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.searchTextField.leftViewMode = UITextField.ViewMode.never
        searchBar.backgroundColor = .designSystemMainBG
        searchBar.searchTextField.backgroundColor = .designSystemMainBG
        searchBar.backgroundImage = UIImage()
        searchBar.searchTextField.backgroundColor = .lightGray.withAlphaComponent(0.3)
        searchBar.searchTextField.subviews.forEach({ $0.removeFromSuperview() })
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(
            string: "Search request",
            attributes: [NSAttributedString.Key.font: UIFont.sfProTextBold17 as Any]
        )
        searchBar.searchTextField.font = .sfProTextBold17
        searchBar.delegate = self
        return searchBar
    }()
    
    override var intrinsicContentSize: CGSize {
        return UIView.layoutFittingExpandedSize
    }
    
    init() {
        super.init(frame: .zero)
        self.setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NavigationSearchBar: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBarHandler?(searchBar.text ?? "")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchBarCancelButtonHandler?()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print(123)
    }
}

private extension NavigationSearchBar {
    func setupLayout() {
        self.backgroundColor = .white
        
        self.addSubview(self.searchBar)
        self.searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.searchBar.topAnchor.constraint(equalTo: self.topAnchor),
            self.searchBar.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.searchBar.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.searchBar.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
        
    }
}
