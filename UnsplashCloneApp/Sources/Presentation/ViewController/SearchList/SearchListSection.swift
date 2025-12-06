//
//  SearchListSection.swift
//  UnsplashCloneApp
//
//  Created by HYUN SUNG on 12/7/25.
//

import RxDataSources

enum SearchListSection {
    case list([SearchListSectionItem])
}

extension SearchListSection: SectionModelType {
    var items: [SearchListSectionItem] {
        switch self {
        case let .list(items): return items
        }
    }
    
    init(original: SearchListSection, items: [SearchListSectionItem]) {
        switch original {
        case .list: self = .list(items)
        }
    }
}

enum SearchListSectionItem {
    case listItem(SearchListItemCellReactor)
}

