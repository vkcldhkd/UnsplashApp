//
//  CollectionActivityIndicatorView.swift
//  UnsplashCloneApp
//
//  Created by HYUN SUNG on 12/7/25.
//

import UIKit

final class CollectionActivityIndicatorView: UICollectionReusableView {
    let activityIndicatorView = UIActivityIndicatorView(style: .medium)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.activityIndicatorView.startAnimating()
        self.addSubview(self.activityIndicatorView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.activityIndicatorView.center = .init(
            x: self.frame.width / 2,
            y: self.frame.height / 2
        )
    }
}

