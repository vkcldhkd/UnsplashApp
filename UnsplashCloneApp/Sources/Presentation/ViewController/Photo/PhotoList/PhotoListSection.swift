//
//  PhotoListSection.swift
//  UnsplashCloneApp
//
//  Created by HYUN SUNG on 12/7/25.
//

import RxDataSources

enum PhotoListSection {
    case list([PhotoListSectionItem])
}

extension PhotoListSection: SectionModelType {
    var items: [PhotoListSectionItem] {
        switch self {
        case let .list(items): return items
        }
    }
    
    init(original: PhotoListSection, items: [PhotoListSectionItem]) {
        switch original {
        case .list: self = .list(items)
        }
    }
}

enum PhotoListSectionItem {
    case listItem(PhotoListItemCellReactor)
}

