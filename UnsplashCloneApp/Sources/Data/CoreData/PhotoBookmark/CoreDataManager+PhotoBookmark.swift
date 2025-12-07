//
//  CoreDataManager+PhotoBookmark.swift
//  UnsplashCloneApp
//
//  Created by HYUN SUNG on 12/8/25.
//

import CoreData

extension CoreDataManager {
    struct photoBookmark {
        fileprivate static let entityName: String = "PhotoBookmark"
        static var entity = NSEntityDescription.entity(
            forEntityName: CoreDataManager.photoBookmark.entityName,
            in: CoreDataManager.shared.managedObjectContext
        )
        fileprivate struct add { }
        fileprivate struct remove { }
        fileprivate struct load { }
        struct action { }
    }
}

// MARK: - Action
extension CoreDataManager.photoBookmark.action {
    static func addPhotoBookmarkItem(photoItem: PhotoItem?) {
        guard let photoItem = photoItem,
              !(photoItem.id ?? "").isEmpty else { return }
        
        CoreDataManager.photoBookmark.add.addPhoto(item: photoItem)
    }
    static func removePhotoBookmarkItem(photoItemID: String?) {
        guard let photoItemID = photoItemID,
              !photoItemID.isEmpty else { return }
        CoreDataManager.photoBookmark.remove.removePhoto(id: photoItemID)
    }
    
    static func loadPhotoBookmarkItems() -> [PhotoItem] {
        return CoreDataManager.photoBookmark.load.loadBookmarkItems() ?? []
    }
}

// MARK: - Add
private extension CoreDataManager.photoBookmark.add {
    static func addPhoto(item: PhotoItem) {
        guard let entity = CoreDataManager.photoBookmark.entity else { return }
        
        let photo = NSManagedObject(entity: entity, insertInto: CoreDataManager.shared.managedObjectContext)

        // MARK: - Base
        photo.setValue(item.id, forKey: "id")
        photo.setValue(item.createdAt, forKey: "createdAt")
        photo.setValue(item.color, forKey: "color")
        photo.setValue(item.width ?? 0, forKey: "width")
        photo.setValue(item.height ?? 0, forKey: "height")
        photo.setValue(Date(), forKey: "date")

        // MARK: - URLS
        photo.setValue(item.urls?.raw, forKey: "raw")
        photo.setValue(item.urls?.full, forKey: "full")
        photo.setValue(item.urls?.regular, forKey: "regular")
        photo.setValue(item.urls?.small, forKey: "small")
        photo.setValue(item.urls?.thumb, forKey: "thumb")
        photo.setValue(item.urls?.smallS3, forKey: "smallS3")

        // MARK: - User
        photo.setValue(item.user?.username, forKey: "username")
        photo.setValue(item.user?.name, forKey: "name")
        photo.setValue(item.user?.firstName, forKey: "firstName")
        photo.setValue(item.user?.lastName, forKey: "lastName")

        // MARK: - Profile Image
        photo.setValue(item.user?.profileImage?.small, forKey: "profileImageSmall")
        photo.setValue(item.user?.profileImage?.medium, forKey: "profileImageMedium")
        photo.setValue(item.user?.profileImage?.large, forKey: "profileImageLarge")

        CoreDataManager.shared.saveContext()
    }
}



// MARK: - Remove
private extension CoreDataManager.photoBookmark.remove {
    static func removePhoto(id: String) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataManager.photoBookmark.entityName)
        request.predicate = NSPredicate(format: "id == %@", id)

        do {
            let results = try CoreDataManager.shared.managedObjectContext.fetch(request)
            if let object = results.first as? NSManagedObject {
                CoreDataManager.shared.managedObjectContext.delete(object)
                CoreDataManager.shared.saveContext()
            }
        } catch {
            print("CoreData Delete Error:", error)
        }
    }
}


// MARK: - Load
private extension CoreDataManager.photoBookmark.load {
    static func loadBookmarkItems() -> [PhotoItem]? {
        guard let entity = CoreDataManager.photoBookmark.entity else { return nil }

        let fetchRequest = NSFetchRequest<PhotoBookmark>(entityName: CoreDataManager.photoBookmark.entityName)
        fetchRequest.entity = entity
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]

        do {
            return try CoreDataManager.shared.managedObjectContext.fetch(fetchRequest)
                .compactMap { CoreDataManager.photoBookmark.convertToPhotoItem(from: $0) }
        } catch {
            print("Failed to fetch loadBookmarkItems: \(error)")
            return nil
        }
    }
}

private extension CoreDataManager.photoBookmark {
    static func convertToPhotoItem(
        from object: NSManagedObject
    ) -> PhotoItem {

        let urls = PhotoURLItem(
            raw: object.value(forKey: "raw") as? String,
            full: object.value(forKey: "full") as? String,
            regular: object.value(forKey: "regular") as? String,
            small: object.value(forKey: "small") as? String,
            thumb: object.value(forKey: "thumb") as? String,
            smallS3: object.value(forKey: "smallS3") as? String
        )

        let profileImage = ProfileImage(
            small: object.value(forKey: "profileImageSmall") as? String,
            medium: object.value(forKey: "profileImageMedium") as? String,
            large: object.value(forKey: "profileImageLarge") as? String
        )

        let user = User(
            id: nil,
            updatedAt: nil,
            username: object.value(forKey: "username") as? String,
            name: object.value(forKey: "name") as? String,
            firstName: object.value(forKey: "firstName") as? String,
            lastName: object.value(forKey: "lastName") as? String,
            profileImage: profileImage
        )

        return PhotoItem(
            id: object.value(forKey: "id") as? String,
            createdAt: object.value(forKey: "createdAt") as? String,
            width: object.value(forKey: "width") as? Int,
            height: object.value(forKey: "height") as? Int,
            color: object.value(forKey: "color") as? String,
            urls: urls,
            user: user
        )
    }
}

