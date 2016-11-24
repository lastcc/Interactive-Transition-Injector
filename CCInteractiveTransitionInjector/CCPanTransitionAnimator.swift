//
//  CCPanTransitionAnimator.swift
//  CCInteractiveTransitionInjector
//
//  Created by 陈成 on 2016/11/24.
//  Copyright © 2016年 陈成. All rights reserved.
//

import UIKit

class CCPanTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromView = transitionContext.view(forKey: .from)!
        let toView = transitionContext.view(forKey: .to)!
        
        let fromViewController = transitionContext.viewController(forKey: .from)!
        let toViewController = transitionContext.viewController(forKey: .to)!
        
        let isPresenting = toViewController.presentingViewController == fromViewController
        
        let fromViewControllerInitialFrame = transitionContext.initialFrame(for: fromViewController)
        let toViewControllerFinalFrame = transitionContext.finalFrame(for: toViewController)
        
        let duration = transitionDuration(using: transitionContext)
        
        fromView.frame = fromViewControllerInitialFrame
        toView.frame = toViewControllerFinalFrame.offsetBy(dx: toViewControllerFinalFrame.width * (isPresenting ? 1:-1), dy: 0)

        transitionContext.containerView.addSubview(toView)
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveLinear, animations: {
            toView.frame = toViewControllerFinalFrame
            fromView.frame = fromViewControllerInitialFrame.offsetBy(dx: fromViewControllerInitialFrame.width * (isPresenting ? -1:1), dy: 0)
        }, completion: { finished in
            let wasCancelled = transitionContext.transitionWasCancelled
            if wasCancelled {
                toView.removeFromSuperview()
            }
            transitionContext.completeTransition(!wasCancelled)
        })
    }
}



