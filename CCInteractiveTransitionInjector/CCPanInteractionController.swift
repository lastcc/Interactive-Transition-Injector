//
//  CCPanInteractionController.swift
//  CCInteractiveTransitionInjector
//
//  Created by 陈成 on 2016/11/24.
//  Copyright © 2016年 陈成. All rights reserved.
//

import UIKit


class CCPanInteractionController: UIPercentDrivenInteractiveTransition {
    
    private var transitionContext: UIViewControllerContextTransitioning!
    private var recognizer: CCPanGestureRecognizer!
    private var initialTranslationInContainerView: CGPoint!
    
    private var shouldFinishTransition: Bool {
        if percent > 0.2 {
            return true
        }
        return false
    }
    
    private var percent: CGFloat {
        guard transitionContext != nil else {
            return 0
        }
        
        let translationInContainerView = recognizer.translation(in: transitionContext.containerView)
        
        if (translationInContainerView.x > 0 && initialTranslationInContainerView.x < 0) ||
            (translationInContainerView.x < 0 && initialTranslationInContainerView.x > 0) {
            return -1
        }
        
        return fabs(translationInContainerView.x) / transitionContext.containerView.bounds.width
    }
    
    func gestureRecognizerDidUpdate(recognizer: CCScreenEdgePanGestureRecognizer) {
        
        switch recognizer.state {
        case .began:
            break;
        case .changed:
            if percent < 0 {
                cancel()
            } else {
                update(percent)
            }
        case .ended:
            shouldFinishTransition ? finish() : cancel()
        default:
            cancel()
        }
    }
    
    override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        self.initialTranslationInContainerView = recognizer.translation(in: transitionContext.containerView)
        self.recognizer.addTarget(self, action: #selector(CCPanInteractionController.gestureRecognizerDidUpdate(recognizer:)))
        super.startInteractiveTransition(transitionContext)
    }
    
    init?(from: UIViewController, to: UIViewController) {
        let gestureRecognizers = from.view.gestureRecognizers ?? []
        let results = gestureRecognizers.flatMap { ($0 as? CCPanGestureRecognizer)?.effectingRecognizer }
        
        guard results.count > 0 else { return nil }
        super.init()
        
        recognizer = results.first!
    }
    
    override func cancel() {
        recognizer.removeTarget(self, action: #selector(CCPanInteractionController.gestureRecognizerDidUpdate(recognizer:)))
        super.cancel()
    }
    
}
