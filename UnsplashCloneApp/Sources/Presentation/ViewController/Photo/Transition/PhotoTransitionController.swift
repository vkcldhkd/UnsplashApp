//
//  PhotoTransitionController.swift
//  UnsplashCloneApp
//
//  Created by HYUN SUNG on 6/7/26.
//

import UIKit

final class PhotoTransitionController: NSObject, UINavigationControllerDelegate {
    func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationController.Operation,
        from fromVC: UIViewController,
        to toVC: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .push:
            guard
                fromVC is PhotoTransitionSource,
                toVC is PhotoTransitionDestination
            else { return nil }

            return PhotoPushTransitionAnimator()

        case .pop:
            guard
                fromVC is PhotoTransitionDestination,
                toVC is PhotoTransitionSource
            else { return nil }

            return PhotoPopTransitionAnimator()

        default:
            return nil
        }
    }
}
