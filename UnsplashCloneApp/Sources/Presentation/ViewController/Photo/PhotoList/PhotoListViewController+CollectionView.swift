//
//  PhotoListViewController+CollectionView.swift
//  UnsplashCloneApp
//
//  Created by HYUN SUNG on 12/8/25.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import RxDataSources

extension PhotoListViewController {
    // MARK: - BindCollectionView
    func bindCollectionView(
        reactor: Reactor,
        dataSource: RxCollectionViewSectionedReloadDataSource<PhotoListSection>
    ) {
        // MARK: - Action
        self.collectionView.rx.isReachedBottom
            .throttle(.microseconds(300), scheduler: MainScheduler.asyncInstance)
            .map { Reactor.Action.loadMore }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.collectionView.rx.itemSelected(dataSource: self.dataSource)
            .throttle(.milliseconds(300), scheduler: MainScheduler.asyncInstance)
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(
                onNext: { [weak self] sectionItem in
                    guard let self = self else { return }
                    switch sectionItem {
                    case let .listItem(cellReactor):
                        let photoItem = cellReactor.currentState.model
                        let repository = PhotoBookmarkRepositoryImpl()
                        let useCase = ToggleBookmarkUseCaseImpl(repository: repository)
                        let detailVC = PhotoDetailViewController(
                            reactor: PhotoDetailViewReactor(
                                model: photoItem,
                                toggleBookmarkUseCase: useCase
                            )
                        )
                    self.navigationController?.pushViewController(detailVC, animated: true)
                }
            })
            .disposed(by: self.disposeBag)
        
        // MARK: - State
        reactor.state.map { $0.sections }
            .bind(to: self.collectionView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
    }
}
