//
//  PhotoRepository.swift
//  UnsplashCloneApp
//
//  Created by HYUN SUNG on 12/6/25.
//

import RxSwift

protocol PhotoRepository {
    func fetchSearchList(
        _ request: PhotoRequest,
        page: Int,
        limit: Int
    ) -> Observable<NetworkResponse<PhotoResponse>?>
}
