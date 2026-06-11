//
//  PhotoViewerViewModel.swift
//  UnsplashCloneApp
//
//  Created by HYUN SUNG on 6/11/26.
//

import UIKit

struct PhotoViewerViewModel {
    let image: UIImage
    let minimumZoomScale: CGFloat
    let maximumZoomScale: CGFloat
    let doubleTapZoomScale: CGFloat

    init(
        image: UIImage,
        minimumZoomScale: CGFloat = 1.0,
        maximumZoomScale: CGFloat = 4.0,
        doubleTapZoomScale: CGFloat = 2.5
    ) {
        self.image = image
        self.minimumZoomScale = minimumZoomScale
        self.maximumZoomScale = maximumZoomScale
        self.doubleTapZoomScale = doubleTapZoomScale
    }
}
