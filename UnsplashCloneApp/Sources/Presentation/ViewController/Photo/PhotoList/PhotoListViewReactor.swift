//
//  PhotoListViewReactor.swift
//  UnsplashCloneApp
//
//  Created by HYUN SUNG on 12/5/25.
//

import ReactorKit
import RxSwift

final class PhotoListViewReactor: Reactor {
    static let limit: Int = 28
    
    enum Action {
        case load
        case loadMore
    }
    
    enum Mutation {
        case setLoading(Bool)
        case setLoadingNextPage(Bool)
        case setSections(PhotoResponse?)
        case appendSections(PhotoResponse?)
    }
    
    struct State {
        var isLoading: Bool
        var isLoadingNextPage: Bool
        
        var loadPhotosUseCase: LoadPhotosUseCase
        var pagination: Pagination?
        var sections: [PhotoListSection]
    }
    
    let initialState: State
    
    init(loadPhotosUseCase: LoadPhotosUseCase) {
        defer { _ = self.state }
        self.initialState = State(
            isLoading: false,
            isLoadingNextPage: false,
            loadPhotosUseCase: loadPhotosUseCase,
            sections: []
        )
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .load:
            guard !self.currentState.isLoading else { return .empty() }
            guard !self.currentState.isLoadingNextPage else { return .empty() }
            let startLoading = Observable<Mutation>.just(.setLoading(true))
            let endLoading = Observable<Mutation>.just(.setLoading(false))
            let setSections = self.currentState.loadPhotosUseCase.execute(.feed, page: 1, limit: PhotoListViewReactor.limit)
                .map { Mutation.setSections($0?.data) }
            return .concat(startLoading, setSections, endLoading)
            
        case .loadMore:
            guard !self.currentState.isLoading else { return .empty() }
            guard !self.currentState.isLoadingNextPage else { return .empty() }
            guard let nextPage = PaginationHelper.getNextPage(pagination: self.currentState.pagination) else { return .empty() }
            let startLoading = Observable<Mutation>.just(.setLoadingNextPage(true))
            let endLoading = Observable<Mutation>.just(.setLoadingNextPage(false))
            let appendSections = self.currentState.loadPhotosUseCase.execute(.feed, page: nextPage, limit: PhotoListViewReactor.limit)
                .map { Mutation.appendSections($0?.data) }
            return .concat([startLoading, appendSections, endLoading])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case let .setLoading(isLoading):
            var newState = state
            newState.isLoading = isLoading
            return newState
            
        case let .setLoadingNextPage(isLoadingNextPage):
            var newState = state
            newState.isLoadingNextPage = isLoadingNextPage
            return newState
            
        case let .setSections(response):
            var newState = state
            let sections = self.createSectionItems(items: response?.items)
            newState.pagination = PaginationHelper.check(
                pagination: Pagination(
                    lastPage: nil,
                    pagePerCount: PhotoListViewReactor.limit,
                    currentPage: 1
                )
            )
            newState.sections = sections
            return newState
            
        case let .appendSections(response):
            var newState = state
            let currentItems = self.currentState.sections
                .compactMap { $0.items }.reduce([], +)
            let appendItems = self.createSectionItems(items: response?.items)
                .compactMap { $0.items }.reduce([], +)
            newState.sections = [.list(currentItems + appendItems)]
            newState.pagination = PaginationHelper.check(
                pagination: Pagination(
                    lastPage: nil,
                    pagePerCount: PhotoListViewReactor.limit,
                    currentPage: (newState.pagination?.currentPage ?? 0) + 1
                )
            )
            return newState
        }
    }
}


private extension PhotoListViewReactor {
    func createSectionItems(items: [PhotoItem]?) -> [PhotoListSection] {
        guard let items = items else { return [] }
        let sectionItems = items
            .compactMap { PhotoListItemCellReactor(model: $0) }
            .compactMap { PhotoListSectionItem.listItem($0) }
            
        return [PhotoListSection.list(sectionItems)]
    }
}
