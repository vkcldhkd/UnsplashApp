//
//  PhotoRequest.swift
//  UnsplashCloneApp
//
//  Created by HYUN SUNG on 12/6/25.
//

import Foundation

enum PhotoRequest: Equatable {
    case feed
    case search(query: String)
}

extension PhotoRequest {
    var baseURL: String {
        switch self {
        case .feed:
            return PhotoEndpoint.feed
        case .search:
            return PhotoEndpoint.search
        }
    }

    var queryItem: URLQueryItem? {
        switch self {
        case .feed:
            return nil
        case let .search(query):
            return URLQueryItem(name: "query", value: query)
        }
    }
}


private enum PhotoEndpoint {
    static let feed = "https://api.unsplash.com/photos"
    static let search = "https://api.unsplash.com/search/photos"
}
