//
//  PhotoBookmarkRepository.swift
//  UnsplashCloneApp
//
//  Created by HYUN SUNG on 12/8/25.
//

import RxSwift

protocol PhotoBookmarkRepository {
    func loadAll() -> [PhotoItem]
    func add(_ item: PhotoItem)
    func remove(id: String)
    func isBookmarked(id: String) -> Bool
}
