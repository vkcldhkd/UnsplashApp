//
//  PhotoBookmarkViewReactor.swift
//  UnsplashCloneApp
//
//  Created by HYUN SUNG on 12/8/25.
//

import ReactorKit
import RxSwift

final class PhotoBookmarkViewReactor: Reactor {
    enum Action {
        case load
    }
    
    enum Mutation {
        case setSectionItems([PhotoItem])
    }
    
    struct State {
        var sections: [PhotoListSection]
    }
    
    let initialState: State
    private let loadBookmarksUseCase: LoadBookmarkedPhotosUseCase
    private let toggleBookmarkUseCase: ToggleBookmarkUseCase
    
    init(
        loadBookmarksUseCase: LoadBookmarkedPhotosUseCase,
        toggleBookmarkUseCase: ToggleBookmarkUseCase
    ) {
        defer { _ = self.state }
        self.loadBookmarksUseCase = loadBookmarksUseCase
        self.toggleBookmarkUseCase = toggleBookmarkUseCase
        self.initialState = State(
            sections: []
        )
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .load:
            let setSectionItems = self.loadBookmarksUseCase.execute()
                .map { Mutation.setSectionItems($0) }
            
            return .concat([setSectionItems])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case let .setSectionItems(items):
            var newState = state
            let sectionItems = self.createSectionItems(items: items)
            newState.sections = [.list(sectionItems)]
            return newState
        }
    }
}

private extension PhotoBookmarkViewReactor {
    func createSectionItems(
        items: [PhotoItem],
    ) -> [PhotoListSectionItem] {
        let toggleBookmarkUseCase = self.toggleBookmarkUseCase
        
        return items
            .map { PhotoListItemCellReactor(model: $0, isLiked: toggleBookmarkUseCase.isLiked(photo: $0)) }
            .map { PhotoListSectionItem.listItem($0) }
    }
}
