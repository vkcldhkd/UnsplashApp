//
//  PhotoBookmarkRepositoryImpl.swift
//  UnsplashCloneApp
//
//  Created by HYUN SUNG on 12/8/25.
//

final class PhotoBookmarkRepositoryImpl: PhotoBookmarkRepository {
    
    private var cachedIDs = Set<String>()
    private var cachedItems: [PhotoItem] = []
    
    init() {
        cachedItems = CoreDataManager.photoBookmark.action.loadPhotoBookmarkItems()
        cachedIDs = Set(cachedItems.compactMap { $0.id })
    }
    
    func loadAll() -> [PhotoItem] {
        return cachedItems
    }
    
    func add(_ item: PhotoItem) {
        guard let id = item.id else { return }
        CoreDataManager.photoBookmark.action.addPhotoBookmarkItem(photoItem: item)
        cachedItems.append(item)
        cachedIDs.insert(id)
    }
    
    func remove(id: String) {
        CoreDataManager.photoBookmark.action.removePhotoBookmarkItem(photoItemID: id)
        cachedItems.removeAll { $0.id == id }
        cachedIDs.remove(id)
    }
    
    func isBookmarked(id: String) -> Bool {
        return cachedIDs.contains(id)
    }
}
