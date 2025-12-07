//
//  PhotoBookmark+CoreDataProperties.swift
//  UnsplashCloneApp
//
//  Created by HYUN SUNG on 12/8/25.
//
//

public import Foundation
public import CoreData


public typealias PhotoBookmarkCoreDataPropertiesSet = NSSet

extension PhotoBookmark {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PhotoBookmark> {
        return NSFetchRequest<PhotoBookmark>(entityName: "PhotoBookmark")
    }

    @NSManaged public var color: String?
    @NSManaged public var createdAt: String?
    @NSManaged public var firstName: String?
    @NSManaged public var full: String?
    @NSManaged public var height: Int64
    @NSManaged public var id: String?
    @NSManaged public var lastName: String?
    @NSManaged public var name: String?
    @NSManaged public var profileImageLarge: String?
    @NSManaged public var profileImageMedium: String?
    @NSManaged public var profileImageSmall: String?
    @NSManaged public var raw: String?
    @NSManaged public var regular: String?
    @NSManaged public var small: String?
    @NSManaged public var smallS3: String?
    @NSManaged public var thumb: String?
    @NSManaged public var username: String?
    @NSManaged public var width: Int64
    @NSManaged public var date: Date?

}

extension PhotoBookmark : Identifiable {

}
