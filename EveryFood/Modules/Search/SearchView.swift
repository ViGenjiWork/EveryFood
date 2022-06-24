//
//  SearchView.swift
//  EveryFood
//
//  Created by Mikhail Zharkov on 15.06.2022.
//

import UIKit

protocol ISearchView: UIView {
    func didLoad()
    func updateFoodSnapshot(with data: [FoodDataDTO])
    var didSelectFoodAtIndexPathHandler: ((IndexPath) -> Void)? { get set }
    var searchBarView: NavigationSearchBar { get }
    var searchBarHandler: ((String) -> Void)? { get set }
    var searchBarCancelButtonHandler: (() -> Void)? { get set }
}

final class SearchView: UIView {
    static let headerElementKind = "search-header"
    
    enum Section: Int, CaseIterable {
        case food
    }
    
    var searchBarView = NavigationSearchBar()
    var searchBarHandler: ((String) -> Void)? {
        didSet {
            self.searchBarView.searchBarHandler = self.searchBarHandler
        }
    }
    var searchBarCancelButtonHandler: (() -> Void)? {
        didSet {
            self.searchBarView.searchBarCancelButtonHandler = self.searchBarCancelButtonHandler
        }
    }
    var didSelectFoodAtIndexPathHandler: ((IndexPath) -> Void)?
    private var foodDataSource: UICollectionViewDiffableDataSource<Section, FoodDataDTO>?
    private let networkService = FoodNetworkService()
    private var searchResultsCount: Int = 0
    
    private lazy var foodCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createFoodCollectionView())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .designSystemSearchBackground
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.layer.cornerRadius = 30
        return collectionView
    }()
}

extension SearchView: ISearchView {
    func didLoad() {
        self.setupUI()
        self.configureFoodDataSource()
    }
    
    func updateFoodSnapshot(with data: [FoodDataDTO]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, FoodDataDTO>()
        snapshot.appendSections([.food])
        snapshot.appendItems(data, toSection: .food)
        print(data.count)
        self.foodDataSource?.apply(snapshot, animatingDifferences: true)
        self.searchResultsCount = data.count
    }
}

// MARK: - Collection View Delegates
extension SearchView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case self.foodCollectionView:
            didSelectFoodAtIndexPathHandler?(indexPath)
        default:
            break
        }
    }
}

private extension SearchView {
    
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
                                                            leading: 40,
                                                            bottom: 10,
                                                            trailing: 40)
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .estimated(44)),
                elementKind: SearchView.headerElementKind,
                alignment: .top)
            section.boundarySupplementaryItems = [sectionHeader]
            
            return section
        }
        return layout
    }
}

// MARK: - Configure DataSource
private extension SearchView {
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

        self.updateSupplementaryRegistration()
    }
    
    func updateSupplementaryRegistration() {
        let supplementaryRegistration = UICollectionView.SupplementaryRegistration
        <TitleSupplementaryView>(elementKind: SearchView.headerElementKind) {
            (supplementaryView, string, indexPath) in
            supplementaryView.titleLabelText = "Found \(self.searchResultsCount) results"
        }
        
        self.foodDataSource?.supplementaryViewProvider = { (view, kind, index) in
            return self.foodCollectionView.dequeueConfiguredReusableSupplementary(
                using: supplementaryRegistration, for: index)
        }
    }
}

// MARK: - Layout
private extension SearchView {
    func setupUI() {
        self.backgroundColor = .designSystemMainBG
        self.setupLayout()
    }
    
    func setupLayout() {
        self.addSubview(self.foodCollectionView)
        self.foodCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.foodCollectionView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            self.foodCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.foodCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.foodCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}

