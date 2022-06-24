//
//  FoodNetworkService.swift
//  EveryFood
//
//  Created by Mikhail Zharkov on 22.06.2022.
//

import Foundation

protocol IFoodNetworkService: AnyObject {
    func loadFoodData<T: Codable>(completion: @escaping(Result<T, Error>)->())
}

final class FoodNetworkService {
    private enum HTTPMethod {
        static let post = "POST"
        static let get = "GET"
    }
}

extension FoodNetworkService: IFoodNetworkService {
    func loadFoodData<T:Decodable>(completion: @escaping (Result<T, Error>) -> ()) {
        let urlString = URLBuilder()
            .withAPI()
            .withPath(path: .foodPath)
            .withMethod(method: .getFood)
            .build()
        let url = URL(string: urlString)
        guard let url = url else { return }
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
            }
            guard let data = data else { return }
            do {
                let newData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(newData))
            }
            catch let error {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func loadFoodImage(urlString: String, completion: @escaping (Result<Data, Error>) -> ()){
        let baseUrl = URLBuilder()
            .build()
        guard let url = URL(string: baseUrl + urlString) else { return }
        let request = URLRequest(url: url)
        URLSession.shared.downloadTask(with: request) { url, response, error in
            if let error = error {
                completion(.failure(error))
            }
            guard let url = url else { return }
            if let data = try? Data(contentsOf: url) {
                completion(.success(data))
            }
        }.resume()
    }
}
