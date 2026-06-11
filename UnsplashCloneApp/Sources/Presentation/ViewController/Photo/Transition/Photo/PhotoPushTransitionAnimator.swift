//
//  PhotoPushTransitionAnimator.swift
//  UnsplashCloneApp
//
//  Created by HYUN SUNG on 6/7/26.
//

import UIKit

final class PhotoPushTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    private let duration: TimeInterval = 0.35

    func transitionDuration(
        using transitionContext: UIViewControllerContextTransitioning?
    ) -> TimeInterval {
        return duration
    }

    func animateTransition(
        using transitionContext: UIViewControllerContextTransitioning
    ) {
        guard
            let fromVC = transitionContext.viewController(forKey: .from) as? PhotoTransitionSource,
            let toVC = transitionContext.viewController(forKey: .to) as? UIViewController & PhotoTransitionDestination,
            let sourceImageView = fromVC.transitionSourceImageView,
            let destinationImageView = toVC.transitionDestinationImageView,
            let image = sourceImageView.image
        else {
            transitionContext.completeTransition(false)
            return
        }

        let containerView = transitionContext.containerView
        let toView = toVC.view!

        containerView.addSubview(toView)

        toVC.prepareTransitionLayout()

        let startFrame = sourceImageView.convert(
            sourceImageView.bounds,
            to: containerView
        )

        let endFrame = destinationImageView.convert(
            destinationImageView.bounds,
            to: containerView
        )

        let snapshotView = UIImageView(image: image)
        snapshotView.contentMode = sourceImageView.contentMode
        snapshotView.clipsToBounds = true
        snapshotView.frame = startFrame
        snapshotView.layer.cornerRadius = sourceImageView.layer.cornerRadius

        sourceImageView.isHidden = true
        destinationImageView.isHidden = true
        toView.alpha = 0

        containerView.addSubview(snapshotView)

        UIView.animate(
            withDuration: duration,
            delay: 0,
            usingSpringWithDamping: 0.9,
            initialSpringVelocity: 0.2,
            options: [.curveEaseInOut]
        ) {
            snapshotView.frame = endFrame
            snapshotView.layer.cornerRadius = destinationImageView.layer.cornerRadius
            toView.alpha = 1
        } completion: { _ in
            sourceImageView.isHidden = false
            destinationImageView.isHidden = false
            snapshotView.removeFromSuperview()

            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
