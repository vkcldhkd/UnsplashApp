//
//  PhotoListItemCellReactor.swift
//  UnsplashCloneApp
//
//  Created by HYUN SUNG on 12/7/25.
//

import ReactorKit
import RxSwift

final class PhotoListItemCellReactor: Reactor {
    enum Action {
    }
    
    enum Mutation {
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
    
    func mutate(action: Action) -> Observable<Mutation> {
        return .empty()
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        return state
    }
}
