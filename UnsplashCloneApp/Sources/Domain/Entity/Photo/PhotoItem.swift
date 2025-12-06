//
//  PhotoElement.swift
//  UnsplashCloneApp
//
//  Created by HYUN SUNG on 12/6/25.
//

import Foundation


// MARK: - PhotoItem
struct PhotoItem: Codable {
    let id: String?
    let createdAt: String?
    let width, height: Int?
    let color: String?
    let urls: PhotoURLItem?

    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case width, height, color, urls
    }
}

// MARK: - Urls
struct PhotoURLItem: Codable {
    let raw, full, regular, small: String?
    let thumb, smallS3: String?

    enum CodingKeys: String, CodingKey {
        case raw, full, regular, small, thumb
        case smallS3 = "small_s3"
    }
}
