//
//  UIScrollView+Rx.swift
//  UnsplashCloneApp
//
//  Created by HYUN SUNG on 12/7/25.
//

import RxCocoa
import UIKit
import RxSwift

extension Reactive where Base: UIScrollView {
    var isReachedBottom: ControlEvent<Void> {
        let source = self.contentOffset
            .filter { [weak base = self.base] offset in
                guard let base = base else { return false }
                return base.isReachedBottom(withTolerance: base.frame.height / 2)
            }
            .map { _ in Void() }
        return ControlEvent(events: source)
    }
    
    var scrollIndicatorInsets: Binder<CGFloat>{
        return Binder(self.base) { base, bottom in
            base.contentInset.bottom = bottom
        }
    }
    
    var contentInset: Binder<UIEdgeInsets>{
        return Binder(self.base) { base, contentInset in
            base.contentInset = contentInset
        }
    }
}
