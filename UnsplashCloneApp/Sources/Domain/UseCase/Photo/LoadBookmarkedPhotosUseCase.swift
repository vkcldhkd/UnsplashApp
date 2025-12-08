//
//  LoadBookmarkedPhotosUseCase.swift
//  UnsplashCloneApp
//
//  Created by HYUN SUNG on 12/8/25.
//

import RxSwift

protocol LoadBookmarkedPhotosUseCase {
    func execute() -> Observable<[PhotoItem]>
    func removed(removeItemID: String?) -> Observable<[PhotoItem]>
}

final class LoadBookmarkedPhotosUseCaseImpl: LoadBookmarkedPhotosUseCase {
    private let repository: PhotoBookmarkRepository

    init(repository: PhotoBookmarkRepository) {
        self.repository = repository
    }

    func execute() -> Observable<[PhotoItem]> {
        return Observable.just(repository.loadAll())
    }
    
    func removed(removeItemID: String?) -> Observable<[PhotoItem]> {
        let filteredItem = repository.loadAll()
            .filter { $0.id != removeItemID }
        return Observable.just(filteredItem)
    }
}
