//
//  PhotoPopTransitionAnimator.swift
//  UnsplashCloneApp
//
//  Created by HYUN SUNG on 6/7/26.
//

import UIKit

final class PhotoPopTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    private let duration: TimeInterval = 0.3
    
    func transitionDuration(
        using transitionContext: UIViewControllerContextTransitioning?
    ) -> TimeInterval {
        return duration
    }
    
    func animateTransition(
        using transitionContext: UIViewControllerContextTransitioning
    ) {
        guard
            let fromVC = transitionContext.viewController(forKey: .from) as? UIViewController & PhotoTransitionDestination,
            let toVC = transitionContext.viewController(forKey: .to) as? UIViewController & PhotoTransitionSource,
            let sourceImageView = fromVC.transitionDestinationImageView,
            let destinationImageView = toVC.transitionSourceImageView,
            let image = sourceImageView.image
        else {
            transitionContext.completeTransition(false)
            return
        }
        
        let containerView = transitionContext.containerView
        let toView = toVC.view!
        
        containerView.insertSubview(toView, belowSubview: fromVC.view)
        
        toView.layoutIfNeeded()
        
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
        
        containerView.addSubview(snapshotView)
        
        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: [.curveEaseInOut]
        ) {
            snapshotView.frame = endFrame
            snapshotView.layer.cornerRadius = destinationImageView.layer.cornerRadius
            fromVC.view.alpha = 0
        } completion: { _ in
            sourceImageView.isHidden = false
            destinationImageView.isHidden = false
            snapshotView.removeFromSuperview()
            fromVC.view.alpha = 1
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
