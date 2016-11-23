//
//  CCEdgePanInteractionController.swift
//  CCInteractiveTransitionInjector
//
//  Created by 陈成 on 2016/11/20.
//  Copyright © 2016年 陈成. All rights reserved.
//

import UIKit

class CCEdgePanInteractionController: UIPercentDrivenInteractiveTransition {
    
    private var transitionContext: UIViewControllerContextTransitioning!
    private var recognizer: CCScreenEdgePanGestureRecognizer!
    
    private var shouldFinishTransition: Bool {
        if percent > 0.4 {
            return true
        }
        return false
    }
    
    private var percent: CGFloat {
        guard transitionContext != nil else {
            return 0
        }
        
        let edges = recognizer.finalEdges
        let locationInSourceView = recognizer.location(in: transitionContext.containerView)
        let width = transitionContext.containerView.bounds.width
        let height = transitionContext.containerView.bounds.height
        
        var percent: CGFloat = 1
        if edges == .top {
            percent = locationInSourceView.y / height
        } else if edges == .right {
            percent = (width - locationInSourceView.x) / width
        } else if edges == .bottom {
            percent = (height - locationInSourceView.y) / height
        } else if edges == .left {
            percent = locationInSourceView.x / width
        }
        
        return percent
    }
    
    func gestureRecognizerDidUpdate(recognizer: CCScreenEdgePanGestureRecognizer) {
        
        switch recognizer.state {
        case .began:
            break;
        case .changed:
            update(percent)
        case .ended:
            shouldFinishTransition ? finish() : cancel()
        default:
            cancel()
        }
    }
    
    override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        super.startInteractiveTransition(transitionContext)
    }
    
    init?(from: UIViewController, to: UIViewController) {
        let gestureRecognizers = from.view.gestureRecognizers ?? []
        let results = gestureRecognizers.flatMap { ($0 as? CCScreenEdgePanGestureRecognizer)?.effectingRecognizer }
        
        guard results.count > 0 else { return nil }
        super.init()

        recognizer = results.first!
        recognizer.addTarget(self, action: #selector(CCEdgePanInteractionController.gestureRecognizerDidUpdate(recognizer:)))
    }
    
    deinit {
        recognizer.removeTarget(self, action: #selector(CCEdgePanInteractionController.gestureRecognizerDidUpdate(recognizer:)))
    }

}
