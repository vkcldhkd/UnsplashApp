//
//  PhotoListViewController+Searchbar.swift
//  UnsplashCloneApp
//
//  Created by HYUN SUNG on 12/8/25.
//

import UIKit
import RxSwift
import ReactorKit
import RxCocoa

extension PhotoListViewController {
    // MARK: - BindSearchBar
    func bindSearchBar(reactor: Reactor) {
        // MARK: - Action
        self.searchBar.rx.searchButtonClicked
            .withLatestFrom(self.searchBar.rx.text.orEmpty)
            .map { Reactor.Action.search($0) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        
        // MARK: - State
    }
}
