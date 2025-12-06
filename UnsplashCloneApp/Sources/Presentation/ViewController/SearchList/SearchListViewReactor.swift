//
//  SearchListViewReactor.swift
//  UnsplashCloneApp
//
//  Created by HYUN SUNG on 12/5/25.
//

import ReactorKit
import RxSwift

final class SearchListViewReactor: Reactor {
    enum Action {
        case load
    }
    
    enum Mutation {
    }
    
    struct State {
        var loadPhotosUseCase: LoadPhotosUseCase
    }
    
    let initialState: State
    
    init(loadPhotosUseCase: LoadPhotosUseCase) {
        defer { _ = self.state }
        self.initialState = State(
            loadPhotosUseCase: loadPhotosUseCase
        )
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .load:
            return self.currentState.loadPhotosUseCase.execute(.feed, page: 1, limit: 10)
                .debug()
                .flatMap { _ in Observable.empty() }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        return state
    }
}
