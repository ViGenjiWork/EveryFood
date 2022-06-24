//
//  URLBuilder.swift
//  EveryFood
//
//  Created by Mikhail Zharkov on 19.06.2022.
//

import Foundation

final class URLBuilder {
    
    enum URLPath: String {
        case foodPath = "food/"
    }
    
    enum URLMethod: String {
       case getFood = "getFood"
    }
    
    private let baseURL: String
    private var path: String?
    private var method: String?
    private var isAPI: String?
    
    func withAPI() -> URLBuilder {
        self.isAPI = "api/v1/"
        return self
    }
    
    func withPath(path: URLPath) -> URLBuilder {
        self.path = path.rawValue
        return self
    }
    
    func withMethod(method: URLMethod) -> URLBuilder {
        self.method = method.rawValue
        return self
    }
    
    func build() -> String {
        return self.baseURL + (self.isAPI ?? "") + (self.path ?? "") + (self.method ?? "")
    }
    
    init() {
        self.isAPI = nil
        self.baseURL = "http://192.168.3.239:8086/"
        self.path = nil
        self.method = nil
    }
}
