//
//  PhotoListViewController+Buttons.swift
//  UnsplashCloneApp
//
//  Created by HYUN SUNG on 12/8/25.
//

import UIKit
import RxSwift
import RxCocoa

extension PhotoListViewController {
    // MARK: - BindButtons
    func bindButtons(reactor: Reactor) {
        // MARK: - Action
        self.heartButton.rx.tap
            .throttle(.milliseconds(700), scheduler: MainScheduler.asyncInstance)
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(
                onNext: { [weak self] _ in
                    let photoBookmarkRepository = PhotoBookmarkRepositoryImpl()
                    let loadBookmarkPhotoUseCase = LoadBookmarkedPhotosUseCaseImpl(repository: photoBookmarkRepository)
                    let toggleBookmarkUseCase = ToggleBookmarkUseCaseImpl(repository: photoBookmarkRepository)
                    let bookmarkViewController = PhotoBookmarkViewController(
                        reactor: PhotoBookmarkViewReactor(
                            loadBookmarksUseCase: loadBookmarkPhotoUseCase,
                            toggleBookmarkUseCase: toggleBookmarkUseCase
                        )
                    )
                self?.navigationController?.pushViewController(bookmarkViewController, animated: true)
            })
            .disposed(by: self.disposeBag)
        // MARK: - State
    }
}
