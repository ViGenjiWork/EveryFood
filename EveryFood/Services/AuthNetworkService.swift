//
//  NetworkService.swift
//  EveryFood
//
//  Created by Mikhail Zharkov on 19.06.2022.
//

import Foundation

protocol IAuthNetworkService: AnyObject {
    func loginUser<T: Codable>(email: String,
                               password: String,
                               completion: @escaping(Result<T, Error>)->())
}

final class AuthNetworkService {
    enum Endpoints {
        static let login = "http://192.168.3.239:8086/api/v1/user/login"
    }
    
    enum HTTPMethod {
        static let post = "POST"
        static let get = "GET"
    }
}

extension AuthNetworkService: IAuthNetworkService {
    func loginUser<T: Decodable>(email: String,
                      password: String,
                      completion: @escaping (Result<T, Error>) -> ()) {
        guard let url = URL(string: Endpoints.login) else { assert(false) }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let parameters = [
            "email": email,
            "password": password,
            "role": "User",
            "device_token": "1234567"
        ]
        let bodyData = try? JSONSerialization.data(
            withJSONObject: parameters,
            options: []
        )
        request.httpBody = bodyData
        
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
}
