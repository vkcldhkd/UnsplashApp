//
//  PhotoListViewReactor.swift
//  UnsplashCloneApp
//
//  Created by HYUN SUNG on 12/5/25.
//

import ReactorKit
import RxSwift

final class PhotoListViewReactor: Reactor {
    enum Action {
        case load
    }
    
    enum Mutation {
        case setLoading(Bool)
        case setSections(PhotoResponse?)
    }
    
    struct State {
        var isLoading: Bool
        var isLoadingNextPage: Bool
        var loadPhotosUseCase: LoadPhotosUseCase
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
            let setSections = self.currentState.loadPhotosUseCase.execute(.feed, page: 1, limit: 28)
                .map { Mutation.setSections($0?.data) }
            return .concat(startLoading, setSections, endLoading)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case let .setLoading(isLoading):
            var newState = state
            newState.isLoading = isLoading
            return newState
            
        case let .setSections(response):
            var newState = state
            let sections = self.createSectionItems(items: response?.items)
            newState.sections = sections
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
