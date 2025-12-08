//
//  UICollectionView+Rx.swift
//  UnsplashCloneApp
//
//  Created by HYUN SUNG on 12/7/25.
//

import UIKit
import RxDataSources
import RxCocoa
import RxSwift

extension Reactive where Base: UICollectionView {
    func itemSelected<S>(dataSource: CollectionViewSectionedDataSource<S>) -> ControlEvent<S.Item> {
        let source = self.itemSelected.map { indexPath in
            dataSource[indexPath]
        }
        return ControlEvent(events: source)
    }
    
    func isEmptyBackground(emptyView: UIView) -> Binder<Bool> {
        return Binder(base) { collectionView, isEmpty in
            if isEmpty {
                emptyView.frame = collectionView.bounds
                collectionView.backgroundView = emptyView
            } else {
                collectionView.backgroundView = nil
            }
        }
    }
}

