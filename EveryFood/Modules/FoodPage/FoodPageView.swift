//
//  FoodPageView.swift
//  EveryFood
//
//  Created by Mikhail Zharkov on 03.06.2022.
//

import UIKit

protocol IFoodPageView: UIView {
    func setData(with data: FoodDataDTO)
    func didLoad()
    
    func updateCarouselSnapshot(with data: [String])
    
    var addToCartActionHandler: (()->Void)? { get set }
}

final class FoodPageView: UIView {
    
    private enum Section: Int, CaseIterable {
        case carousel
    }
 
    private var carouselDataSource: UICollectionViewDiffableDataSource<Section, String>?
    
    private lazy var scrollView = UIScrollView()
    private lazy var contentView = UIView()
    private let networkService = FoodNetworkService()
    
    private lazy var carouselCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: self.createCompositionalLayout())
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .designSystemMainBG
        return collectionView
    }()
    
    private lazy var carouselControl: UIPageControl = {
        let carouselControl = UIPageControl()
        carouselControl.pageIndicatorTintColor = .designSystemPageControl
        carouselControl.currentPageIndicatorTintColor = .designSystemOrange
        carouselControl.isUserInteractionEnabled = false
        return carouselControl
    }()
    
    private lazy var foodTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .sfProTextBold22
        label.textAlignment = .center
        return label
    }()
    
    private lazy var foodPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .sfProTextBold22
        label.textColor = .designSystemOrange
        label.textAlignment = .center
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .sfProTextBold17
        label.text = "Description:"
        return label
    }()
    
    private lazy var foodDescriptionTextLabel: UILabel = {
        let label = UILabel()
        label.font = .sfProTextBold17
        label.textColor = .designSystemInactiveLabel
        return label
    }()
    
    private lazy var compoundLabel: UILabel = {
        let label = UILabel()
        label.font = .sfProTextBold17
        label.text = "Compound:"
        return label
    }()
    
    private lazy var foodCompoundTextLabel: UILabel = {
        let label = UILabel()
        label.font = .sfProTextBold17
        label.textColor = .designSystemInactiveLabel
        return label
    }()
    
    private lazy var button = Button(with: .init(title: "Add to cart", tapHandler: {
        self.addToCart()
    }))
    
    var addToCartActionHandler: (() -> Void)?
    
    func addToCart() {
        self.addToCartActionHandler?()
    }
}

extension FoodPageView: IFoodPageView {
    func setData(with data: FoodDataDTO) {
        if data.images.count > 1 {
            self.carouselControl.numberOfPages = data.images.count
        }
        self.foodTitleLabel.text = data.title
        self.foodPriceLabel.text = "\(data.price) ₽"
        self.foodDescriptionTextLabel.text = data.description
        self.foodCompoundTextLabel.text = data.compound
    }
    
    func didLoad() {
        self.setupLayout()
        self.configureCarouselDataSource()
    }
    
    func updateCarouselSnapshot(with data: [String]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        snapshot.appendSections([.carousel])
        snapshot.appendItems(data, toSection: .carousel)
        self.carouselDataSource?.apply(snapshot, animatingDifferences: true)
    }
}

private extension FoodPageView {
    func setupLayout() {
        self.backgroundColor = .designSystemMainBG
        
        self.addSubview(self.scrollView)
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.scrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            self.scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        self.addSubview(self.contentView)
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.contentView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.contentView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
            self.contentView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor)
        ])
        
        self.scrollView.addSubview(self.carouselCollectionView)
        self.carouselCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.carouselCollectionView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            self.carouselCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.carouselCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.carouselCollectionView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.7)
        ])
        
        self.scrollView.addSubview(self.carouselControl)
        self.carouselControl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.carouselControl.topAnchor.constraint(equalTo: self.carouselCollectionView.bottomAnchor, constant: 30),
            self.carouselControl.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.carouselControl.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.carouselControl.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        self.scrollView.addSubview(self.foodTitleLabel)
        self.foodTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.foodTitleLabel.topAnchor.constraint(equalTo: self.carouselControl.bottomAnchor),
            self.foodTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.foodTitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
        
        self.scrollView.addSubview(self.foodPriceLabel)
        self.foodPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.foodPriceLabel.topAnchor.constraint(equalTo: self.foodTitleLabel.bottomAnchor, constant: 10),
            self.foodPriceLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.foodPriceLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
        
        self.scrollView.addSubview(self.descriptionLabel)
        self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.descriptionLabel.topAnchor.constraint(equalTo: self.foodPriceLabel.bottomAnchor, constant: 10),
            self.descriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            self.descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
        
        self.scrollView.addSubview(self.foodDescriptionTextLabel)
        self.foodDescriptionTextLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.foodDescriptionTextLabel.topAnchor.constraint(equalTo: self.descriptionLabel.bottomAnchor, constant: 10),
            self.foodDescriptionTextLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            self.foodDescriptionTextLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
        
        self.scrollView.addSubview(self.compoundLabel)
        self.compoundLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.compoundLabel.topAnchor.constraint(equalTo: self.foodDescriptionTextLabel.bottomAnchor, constant: 10),
            self.compoundLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            self.compoundLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
        
        self.scrollView.addSubview(self.foodCompoundTextLabel)
        self.foodCompoundTextLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.foodCompoundTextLabel.topAnchor.constraint(equalTo: self.compoundLabel.bottomAnchor, constant: 10),
            self.foodCompoundTextLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            self.foodCompoundTextLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
        
        self.addSubview(self.button)
        self.button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.button.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            self.button.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            self.button.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30),
            self.button.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
}

private extension FoodPageView {
    func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int,
                                                            layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalHeight(1.0))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                           subitem: item,
                                                           count: 1)

            let section = NSCollectionLayoutSection(group: group)
            section.visibleItemsInvalidationHandler = { [weak self] (items, offset, env) -> Void in
                guard let self = self else { return }
                let page = round(offset.x / self.bounds.width)
                self.carouselControl.currentPage = Int(page)
            }

            section.orthogonalScrollingBehavior = .paging
            return section
        }
        return layout
    }
}

private extension FoodPageView {
    func configureCarouselDataSource() {
        let cellRegistration = UICollectionView.CellRegistration
        <FoodPageCollectionViewCell, String> { (cell, indexPath, item) in
            self.networkService.loadFoodImage(urlString: item) { (result: Result<Data, Error>) in
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
        
        self.carouselDataSource = UICollectionViewDiffableDataSource<Section, String>(collectionView: self.carouselCollectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: String) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
    }
}
