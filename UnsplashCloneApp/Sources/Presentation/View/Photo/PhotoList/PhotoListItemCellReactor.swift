//
//  PhotoListItemCellReactor.swift
//  UnsplashCloneApp
//
//  Created by HYUN SUNG on 12/7/25.
//

import ReactorKit
import RxSwift

final class PhotoListItemCellReactor: Reactor {
    typealias Action = NoAction
    
    enum Mutation {
        case setLiked(Bool)
    }
    
    struct State {
        var model: PhotoItem
        var isLiked: Bool
    }
    
    let initialState: State
    
    init(
        model: PhotoItem,
        isLiked: Bool = false
    ) {
        defer { _ = self.state }
        self.initialState = State(
            model: model,
            isLiked: isLiked
        )
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let fromPhotoItemEvent = PhotoItem.event
            .withUnretained(self)
            .flatMap { $0.0.fromPhotoItemEvent(from: $0.1) }
        
        return Observable.of(mutation, fromPhotoItemEvent).merge()
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case let .setLiked(isLiked):
            var newState = state
            newState.isLiked = isLiked
            return newState
        }
    }
}


private extension PhotoListItemCellReactor {
    func fromPhotoItemEvent(
        from event: PhotoItem.Event
    ) -> Observable<Mutation> {
        switch event {
        case let .like(item, isLiked):
            guard self.currentState.model.id == item.id else { return .empty() }
            let setLiked = Observable<Mutation>.just(.setLiked(isLiked))
            return .concat([setLiked])
        }
    }
}
