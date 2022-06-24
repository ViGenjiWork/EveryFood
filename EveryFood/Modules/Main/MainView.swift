//
//  MainView.swift
//  EveryFood
//
//  Created by Mikhail Zharkov on 31.05.2022.
//

import UIKit

protocol IMainView: UIView {
    func didLoad()
    func setData(with data: FoodDataDTO)
    
    func updateFoodSnapshot(with data: [FoodDataDTO])
    func updateCategoriesSnapshot(with data: [String])
    
    func deselectCategory(for indexPath: IndexPath)
    func selectCategory(for indexPath: IndexPath)
    
    var searchBarButtonActionHandler: (() -> Void)? { get set }
    var didSelectFoodAtIndexPathHandler: ((IndexPath) -> Void)? { get set }
    var didSelectCategoryAtIndexPathHandler: ((IndexPath) -> Void)? { get set }
}

final class MainView: UIView {
    
    private enum Metrics {
        static let titleLabelTopOffset: CGFloat = 10
        static let titleLabelHorizontalOffset: CGFloat = 50
    }
    
    private enum Colors {
        static let selectedCategory: UIColor = .designSystemOrange
        static let deselectedCategory: UIColor = .designSystemInactiveLabel
    }
    
    private enum Section: Int, CaseIterable {
        case categories
        case food
    }

    private var categoryDataSource: UICollectionViewDiffableDataSource<Section, String>?
    private var foodDataSource: UICollectionViewDiffableDataSource<Section, FoodDataDTO>?
    private var networkService = FoodNetworkService()
    
    var searchBarButtonActionHandler: (() -> Void)?
    var didSelectFoodAtIndexPathHandler: ((IndexPath) -> Void)?
    var didSelectCategoryAtIndexPathHandler: ((IndexPath) -> Void)?
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .sfProTextBold34
        label.numberOfLines = 2
        label.text = "Delicious \nfood for you"
        return label
    }()
    
    private lazy var searchBarButton: UIView = {
        let view = UIView()
        view.backgroundColor = .designSystemSearchBarBtn
        view.layer.cornerRadius = 30
        let action = UITapGestureRecognizer(target: self, action: #selector(self.searchBarButtonAction))
        view.addGestureRecognizer(action)
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private let searchBarButtonIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "search-icon")
        return imageView
    }()
    
    private let searchBarButtonPlaceholder: UILabel = {
        let label = UILabel()
        label.font = .sfProTextBold17
        label.textColor = .designSystemSearchBarPlaceholder
        label.text = "Search"
        return label
    }()
    
    private lazy var categoriesCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createCategoriesCollectionView())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .designSystemMainBG
        collectionView.delegate = self
        return collectionView
    }()
    
    private lazy var foodCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createFoodCollectionView())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .designSystemMainBG
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        return collectionView
    }()
    
}

extension MainView: IMainView {
    func selectCategory(for indexPath: IndexPath) {
        guard let cell = self.categoriesCollectionView.cellForItem(at: indexPath)
                as? CategoryCollectionViewCell else { return }
        cell.categoryLabel.textColor = Colors.selectedCategory
    }
    
    func deselectCategory(for indexPath: IndexPath) {
        guard let cell = self.categoriesCollectionView.cellForItem(at: indexPath)
                as? CategoryCollectionViewCell else { return }
        cell.categoryLabel.textColor = Colors.deselectedCategory
    }
    
    func updateFoodSnapshot(with data: [FoodDataDTO]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, FoodDataDTO>()
        snapshot.appendSections([.food])
        snapshot.appendItems(data, toSection: .food)
        self.foodDataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    func updateCategoriesSnapshot(with data: [String]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        snapshot.appendSections([.categories])
        snapshot.appendItems(data, toSection: .categories)
        self.categoryDataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    func didLoad() {
        self.setupUI()
        self.configureCategoryDataSource()
        self.configureFoodDataSource()
    }
    
    func setData(with data: FoodDataDTO) {
        
    }
}

private extension MainView {
    @objc func searchBarButtonAction() {
        self.searchBarButtonActionHandler?()
    }
}


// MARK: - Setup Constraints
private extension MainView {
    func setupUI() {
        self.backgroundColor = .designSystemMainBG
        self.setupLayout()
        self.setupSearchBarButton()
    }
    
    func setupLayout() {
        self.addSubview(self.titleLabel)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor,
                                                 constant: Metrics.titleLabelTopOffset),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                                     constant: Metrics.titleLabelHorizontalOffset),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                                      constant: -Metrics.titleLabelHorizontalOffset),
        ])
        
        self.addSubview(self.searchBarButton)
        self.searchBarButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.searchBarButton.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 10),
            self.searchBarButton.heightAnchor.constraint(equalToConstant: 60),
            self.searchBarButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 50),
            self.searchBarButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -50),
        ])
        
        self.addSubview(self.categoriesCollectionView)
        self.categoriesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.categoriesCollectionView.topAnchor.constraint(equalTo: self.searchBarButton.bottomAnchor, constant: 10),
            self.categoriesCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            self.categoriesCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30),
            self.categoriesCollectionView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        self.addSubview(self.foodCollectionView)
        self.foodCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.foodCollectionView.topAnchor.constraint(equalTo: self.categoriesCollectionView.bottomAnchor),
            self.foodCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            self.foodCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30),
            self.foodCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    func setupSearchBarButton() {
        self.searchBarButton.addSubview(self.searchBarButtonIcon)
        self.searchBarButtonIcon.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.searchBarButtonIcon.centerYAnchor.constraint(equalTo: self.searchBarButton.centerYAnchor),
            self.searchBarButtonIcon.leadingAnchor.constraint(equalTo: self.searchBarButton.leadingAnchor, constant: 35)
        ])
        
        self.searchBarButton.addSubview(self.searchBarButtonPlaceholder)
        self.searchBarButtonPlaceholder.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.searchBarButtonPlaceholder.centerYAnchor.constraint(equalTo: self.searchBarButton.centerYAnchor),
            self.searchBarButtonPlaceholder.leadingAnchor.constraint(equalTo: self.searchBarButtonIcon.leadingAnchor, constant: 35)
        ])
    }
}

// MARK: - Create CollectionView Layout
private extension MainView {
    func createCategoriesCollectionView() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int,
                                                            layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.33),
                                                   heightDimension: .fractionalHeight(1.0))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                           subitem: item,
                                                           count: 1)
            group.interItemSpacing = .fixed(20)

            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            return section
        }
        return layout
    }
    
    func createFoodCollectionView() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int,
                                                            layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection in
            let columns = 2
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalWidth(0.8))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalWidth(0.8))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                           subitem: item,
                                                           count: columns)
            group.interItemSpacing = .fixed(20)
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 20
            section.contentInsets = NSDirectionalEdgeInsets(top: 10,
                                                            leading: 10,
                                                            bottom: 10,
                                                            trailing: 10)
            return section
        }
        return layout
    }
}


// MARK: - Configure DataSource
private extension MainView {
    func configureCategoryDataSource() {
        let cellRegistration = UICollectionView.CellRegistration
        <CategoryCollectionViewCell, String> { (cell, indexPath, item) in
            cell.setData(with: item)
            cell.didLoad()
        }
        
        self.categoryDataSource = UICollectionViewDiffableDataSource<Section, String>(collectionView: self.categoriesCollectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: String) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
    }
    func configureFoodDataSource() {
        let cellRegistration = UICollectionView.CellRegistration
        <FoodCollectionViewCell, FoodDataDTO> { (cell, indexPath, item) in
            cell.setData(with: item)
            guard let urlString = item.images.first else { return }
            self.networkService.loadFoodImage(urlString: urlString) { (result: Result<Data, Error>) in
                switch result {
                case .success(let success):
                    DispatchQueue.main.async {
                        cell.imageData = success
                    }
                case .failure(let failure):
                    print(failure.localizedDescription)
                }
            }
            cell.didLoad()
        }
        
        self.foodDataSource = UICollectionViewDiffableDataSource<Section, FoodDataDTO>(collectionView: self.foodCollectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: FoodDataDTO) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
    }
}

// MARK: - Collection View Delegates
extension MainView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case self.foodCollectionView:
            didSelectFoodAtIndexPathHandler?(indexPath)
            
        case self.categoriesCollectionView:
            didSelectCategoryAtIndexPathHandler?(indexPath)
            
        default:
            break
        }
    }
}

