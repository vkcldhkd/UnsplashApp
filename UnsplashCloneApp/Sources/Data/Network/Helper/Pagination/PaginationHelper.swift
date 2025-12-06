//
//  PaginationHelper.swift
//  UnsplashCloneApp
//
//  Created by HYUN SUNG on 12/6/25.
//

import Foundation

struct PaginationHelper {
    static func check(
        pagination: Pagination?
    ) -> Pagination? {
        guard let pagination = pagination,
              pagination.hasNextPage() else { return nil }
        return pagination
    }
    
    static func getNextPage(
        pagination: Pagination?
    ) -> Int? {
        guard let pagination = pagination,
              pagination.hasNextPage(),
              let currentPage = pagination.currentPage else { return nil }

        return currentPage + 1
    }
}
