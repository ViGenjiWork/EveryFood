//
//  CartDataSource.swift
//  EveryFood
//
//  Created by Mikhail Zharkov on 24.06.2022.
//

import Foundation
import UIKit


final class CartDataSource: NSObject, UITableViewDataSource {
    
    var data: [FoodModel] = []
    let networkService = FoodNetworkService()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CartTableViewCell.identifier, for: indexPath) as? ICartTableViewCell else { return UITableViewCell() }
        cell.didLoad()
        if let urlString = data[indexPath.section].image {
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
        }
        cell.setData(with: data[indexPath.section])
        return cell
    }
}

