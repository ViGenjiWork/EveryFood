//
//  UserDTO.swift
//  EveryFood
//
//  Created by Mikhail Zharkov on 19.06.2022.
//

import Foundation

struct UserDTO: Codable {
    let status: Int
    let remarks: String
    let data: UserDataDTO?
}

struct UserDataDTO: Codable {
    let active: Bool
    let userType, id, fullName, email: String
    let gender, contactNumber, role, deviceToken: String
    let accessToken, avatar: String

    enum CodingKeys: String, CodingKey {
        case active = "Active"
        case userType = "user_type"
        case id = "_id"
        case fullName = "full_name"
        case email = "email"
        case gender = "gender"
        case contactNumber = "contactNumber"
        case role = "role"
        case deviceToken = "device_token"
        case accessToken = "access_token"
        case avatar = "avatar"
    }
}
