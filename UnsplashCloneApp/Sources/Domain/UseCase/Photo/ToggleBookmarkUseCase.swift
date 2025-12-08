//
//  ToggleBookmarkUseCase.swift
//  UnsplashCloneApp
//
//  Created by HYUN SUNG on 12/8/25.
//

import RxSwift
import RxCocoa

protocol ToggleBookmarkUseCase {
    func isLiked(photo: PhotoItem) -> Bool
    func execute(photo: PhotoItem) -> Observable<Bool>
}

final class ToggleBookmarkUseCaseImpl: ToggleBookmarkUseCase {

    private let repository: PhotoBookmarkRepository

    init(repository: PhotoBookmarkRepository) {
        self.repository = repository
    }

    func isLiked(photo: PhotoItem) -> Bool {
        guard let id = photo.id else { return false }
        return repository.isBookmarked(id: id)
    }
    
    func execute(photo: PhotoItem) -> Observable<Bool> {
        guard let id = photo.id else { return Observable.just(false) }
        
        if repository.isBookmarked(id: id) {
            repository.remove(id: id)
            PhotoItem.event.onNext(.like(item: photo, isLiked: false))
            return Observable.just(false)
        } else {
            repository.add(photo)
            PhotoItem.event.onNext(.like(item: photo, isLiked: true))
            return Observable.just(true)
        }
    }
}
