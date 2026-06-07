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
    private let clientID: String

    init(clientID: String) {
        self.clientID = clientID
    }
    
    func fetchSearchList(
        _ request: PhotoRequest,
        page: Int,
        limit: Int
    ) -> Observable<NetworkResponse<PhotoResponse>?> {
        let path = URLHelper.createAbsolutePath(
            baseURL: request.baseURL,
            queryItems: makeQueryItems(
                request: request,
                page: page,
                limit: limit
            )
        )

        return NetworkManager.request(method: .get, url: path)
            .map { try? NetworkResponse<PhotoResponse>(path: path, json: $0) }
    }
}

private extension PhotoRepositoryImpl {
    func makeQueryItems(
        request: PhotoRequest,
        page: Int,
        limit: Int
    ) -> [URLQueryItem] {
        var items = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "\(limit)"),
            URLQueryItem(name: "client_id", value: clientID)
        ]

        if let queryItem = request.queryItem {
            items.insert(queryItem, at: 0)
        }

        return items
    }
}
