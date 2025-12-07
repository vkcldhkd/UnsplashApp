//
//  User.swift
//  UnsplashCloneApp
//
//  Created by HYUN SUNG on 12/7/25.
//

struct User: Codable, Equatable {
    let id: String?
    let updatedAt: String?
    let username, name, firstName, lastName: String?
    let profileImage: ProfileImage?

    enum CodingKeys: String, CodingKey {
        case id
        case updatedAt = "updated_at"
        case username, name
        case firstName = "first_name"
        case lastName = "last_name"
        case profileImage = "profile_image"
    }
}

struct ProfileImage: Codable, Equatable {
    let small, medium, large: String?
}
