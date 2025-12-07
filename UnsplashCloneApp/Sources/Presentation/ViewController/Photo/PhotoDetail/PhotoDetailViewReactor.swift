//
//  PhotoDetailViewReactor.swift
//  UnsplashCloneApp
//
//  Created by HYUN SUNG on 12/7/25.
//

import ReactorKit
import RxSwift

final class PhotoDetailViewReactor: Reactor {
    enum Action {
        case updateLiked
    }
    
    enum Mutation {
        case setLiked(Bool)
    }
    
    struct State {
        var isLiked: Bool
        var model: PhotoItem
        var rows: [PhotoDetailRow]
    }
    
    let initialState: State
    
    init(model: PhotoItem) {
        defer { _ = self.state }
        
        let rows = PhotoDetailViewReactor.createRows(model: model)
        self.initialState = State(
            isLiked: false,
            model: model,
            rows: rows
        )
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .updateLiked:
            let setLiked = Observable<Mutation>.just(.setLiked(!self.currentState.isLiked))
            return Observable.concat([setLiked])
        }
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

private extension PhotoDetailViewReactor {
    static func createRows(model: PhotoItem) -> [PhotoDetailRow] {
        return [
            .init(title: "ID", value: model.id),
            .init(title: "Author", value: model.user?.username),
            .init(title: "Size", value: PhotoDetailViewReactor.createSize(width: model.width, height: model.height)),
            .init(title: "Created At", value: model.createdAt)
        ]
    }
    
    static func createSize(width: Int?, height: Int?) -> String {
        return "\(width ?? 0) x \(height ?? 0)"
    }
}


