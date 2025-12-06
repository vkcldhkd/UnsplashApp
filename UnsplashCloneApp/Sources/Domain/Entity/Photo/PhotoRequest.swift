//
//  PhotoRequest.swift
//  UnsplashCloneApp
//
//  Created by HYUN SUNG on 12/6/25.
//

enum PhotoRequest: Equatable {
    case feed
    case search(query: String)
}
