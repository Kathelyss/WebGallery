//
//  TransitionAnimator.swift
//  WebGallery
//
//  Created by kathelyss on 16/02/2019.
//  Copyright © 2019 Екатерина Рыжова. All rights reserved.
//

import UIKit

class TransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    let duration = 0.3
    var presenting = true
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if presenting, let tabBarVC = transitionContext.viewController(forKey: .from) as? UITabBarController,
            let fromVC = tabBarVC.selectedViewController as? WebGalleryVC,
            let toVC = transitionContext.viewController(forKey: .to) as? ImageVC {
            guard let cellIndexPath = fromVC.collectionView.indexPathsForSelectedItems?.first else {
                transitionContext.completeTransition(false)
                return
            }
            
            let container = transitionContext.containerView
            if let cell = fromVC.collectionView.cellForItem(at: cellIndexPath) as? WebGalleryCell {
                let cellInCollView = cell.convert(cell.imageView.frame, to: fromVC.collectionView)
                toVC.view.setNeedsLayout()
                toVC.view.layoutIfNeeded()
                let animationInitialFrame = fromVC.collectionView.convert(cellInCollView, to: nil)
                let animationFinalFrame = toVC.imageView.frame
                guard let snapshotView = cell.imageView.snapshotView(afterScreenUpdates: false) else {
                    transitionContext.completeTransition(false)
                    return
                }
                
                snapshotView.frame = animationInitialFrame
                toVC.view.addSubview(snapshotView)
                toVC.imageView.isHidden = true
                container.addSubview(toVC.view)
                
                toVC.backGroundBlur = BlurryOverlayView()
                toVC.backGroundBlur?.frame = toVC.view.bounds
                toVC.view.insertSubview(toVC.backGroundBlur!, belowSubview: toVC.imageView)
                toVC.backGroundBlur?.blurIn(amount: CGFloat(duration), duration: duration)
                
                let animator = UIViewPropertyAnimator.init(duration: duration, curve: .easeInOut) {
                    snapshotView.frame = animationFinalFrame
                }
                
                animator.addCompletion { _ in
                    toVC.circlePulsatorView.frame = toVC.view.bounds
                    toVC.view.addSubview(toVC.circlePulsatorView)
                    toVC.circlePulsatorView.setup()
                    toVC.circlePulsatorView.startPulsations(from: CircleSize.min, to: CircleSize.max)
                    toVC.imageView.isHidden = false
                    snapshotView.removeFromSuperview()
                    transitionContext.completeTransition(true)
                }
                animator.startAnimation()
                
            }
        } else if !presenting, let fromVC = transitionContext.viewController(forKey: .from) as? ImageVC,
            let tabBarVC = transitionContext.viewController(forKey: .to) as? UITabBarController,
            let toVC = tabBarVC.selectedViewController as? WebGalleryVC {
            guard let cellIndexPath = toVC.collectionView.indexPathsForSelectedItems?.first else {
                transitionContext.completeTransition(false)
                return
            }
            
            if let cell = toVC.collectionView.cellForItem(at: cellIndexPath) as? WebGalleryCell {
                let cellInCollView = cell.convert(cell.imageView.frame, to: toVC.collectionView)
                
                let animationInitialFrame = fromVC.imageView.frame
                let animationFinalFrame = toVC.collectionView.convert(cellInCollView, to: nil)
                guard let snapshotView = fromVC.imageView.snapshotView(afterScreenUpdates: false) else {
                    transitionContext.completeTransition(false)
                    return
                }
                
                snapshotView.frame = animationInitialFrame
                fromVC.view.addSubview(snapshotView)
                fromVC.imageView.isHidden = true
                fromVC.backGroundBlur?.blurOut(duration: duration)
                let animator = UIViewPropertyAnimator.init(duration: duration, curve: .easeInOut) {
                    snapshotView.frame = animationFinalFrame
                    snapshotView.layer.cornerRadius = cell.layer.cornerRadius
                }
                animator.addCompletion { _ in
                    fromVC.view.removeFromSuperview()
                    snapshotView.removeFromSuperview()
                    transitionContext.completeTransition(true)
                }
                animator.startAnimation()
                
            }
        }
    }
}

