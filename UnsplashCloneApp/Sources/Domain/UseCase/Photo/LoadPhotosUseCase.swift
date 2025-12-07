//
//  LoadPhotosUseCase.swift
//  UnsplashCloneApp
//
//  Created by HYUN SUNG on 12/6/25.
//

import RxSwift

protocol LoadPhotosUseCase {
    func fetchPhotos(
        _ request: PhotoRequest,
        page: Int,
        limit: Int
    ) -> Observable<NetworkResponse<PhotoResponse>?>
}

final class LoadPhotosUseCaseImpl: LoadPhotosUseCase {
    private let repository: PhotoRepository
    
    init(repository: PhotoRepository) {
        self.repository = repository
    }

    func fetchPhotos(
        _ request: PhotoRequest,
        page: Int,
        limit: Int
    ) -> Observable<NetworkResponse<PhotoResponse>?> {
        return repository.fetchSearchList(request, page: page, limit: limit)
    }
}
