//
//  PhotoRepositoryImpl.swift
//  UnsplashCloneApp
//
//  Created by HYUN SUNG on 12/6/25.
//

import RxSwift
import Foundation
import Alamofire

/*
 client_id: UKHUCSynoHy_OOV_e-5Joa81I5JGwWaO1OAV8iFTonU
 
 feed(page,per_page,client_id)
 https://api.unsplash.com/photos/?client_id=UKHUCSynoHy_OOV_e-5Joa81I5JGwWaO1OAV8iFTonU
 
 
 search(page, per_page, client_id,query)
 https://api.unsplash.com/search/photos?page=1&query=office&client_id=UKHUCSynoHy_OOV_e-5Joa81I5JGwWaO1OAV8iFTonU
 
 */


final class PhotoRepositoryImpl: PhotoRepository {
    private static let feedBaseURL: String = "https://api.unsplash.com/photos"
    private static let searchBaseURL: String = "https://api.unsplash.com/search/photos"
    private static let clientID: String = "UKHUCSynoHy_OOV_e-5Joa81I5JGwWaO1OAV8iFTonU"
    
    func fetchSearchList(
        _ request: PhotoRequest,
        page: Int,
        limit: Int
    ) -> Observable<NetworkResponse<PhotoResponse>?> {
        let queryItems: [URLQueryItem]? = PhotoRepositoryImpl.createURLItems(
            request: request,
            page: page,
            limit: limit
        )
        
        let path: String = URLHelper.createAbsolutePath(
            baseURL: request == .feed ? PhotoRepositoryImpl.feedBaseURL : PhotoRepositoryImpl.searchBaseURL ,
            queryItems: queryItems
        )
        return NetworkManager.request(method: .get, url: path)
            .map { try? NetworkResponse<PhotoResponse>(path: path, json: $0) }
    }
}

private extension PhotoRepositoryImpl {
    static func createURLItems(
        request: PhotoRequest,
        page: Int,
        limit: Int
    ) -> [URLQueryItem]? {
        switch request {
        case .feed:
            return [
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "per_page", value: "\(limit)"),
                URLQueryItem(name: "client_id", value: PhotoRepositoryImpl.clientID),
            ]
        case let .search(query):
            return [
                URLQueryItem(name: "query", value: query),
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "per_page", value: "\(limit)"),
                URLQueryItem(name: "client_id", value: PhotoRepositoryImpl.clientID),
            ]
        }
    }
    
    
}
