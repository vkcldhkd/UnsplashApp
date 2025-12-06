//
//  Pagination.swift
//  UnsplashCloneApp
//
//  Created by HYUN SUNG on 12/6/25.
//

import Foundation

// MARK: - Pagination
struct Pagination: Codable, Equatable {
    let lastPage, pagePerCount: Int?
    var currentPage: Int?
}

extension Pagination {
    func hasNextPage() -> Bool {
// 해당 API에서 lastpage 관련된 정보가 내려오지않아서, 무조건 true로 리턴되도록 수정
//        let currentPage = self.currentPage ?? 0
//        let lastPage = self.lastPage ?? 0
//        return currentPage < lastPage
        return true
    }
    
    func hasPreviousPage() -> Bool {
        let currentPage = self.currentPage ?? 0
        return currentPage > 0
    }
}
