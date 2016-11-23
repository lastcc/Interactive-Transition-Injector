//
//  CCStoryboardObjects+Recognizer.swift
//  CCInteractiveTransitionInjector
//
//  Created by 陈成 on 2016/11/20.
//  Copyright © 2016年 陈成. All rights reserved.
//

import UIKit


class CCScreenEdgePanGestureRecognizer: UIScreenEdgePanGestureRecognizer {
    
    // NOTE: Variable `finalEdges` is introduced to fix an issue prior to iOS 8.3
    //       - always return .none when querying its edges property.
    var finalEdges: UIRectEdge = .right {
        didSet {
            edges = finalEdges
        }
    }
    
    var effectingRecognizer: CCScreenEdgePanGestureRecognizer? {
        let effectiveStates: [UIGestureRecognizerState] = [.began, .changed]
        if effectiveStates.contains(state) {
            return self
        }
        return nil
    }
}

class CCStoryboardSegue: UIStoryboardSegue, UIViewControllerTransitioningDelegate {
    
    override init(identifier: String?, source: UIViewController, destination: UIViewController) {
        super.init(identifier: identifier, source: source, destination: destination)
        destination.transitioningDelegate = self
        destination.modalPresentationStyle = .fullScreen
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CCSwipeTransitionAnimator()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CCSwipeTransitionAnimator()
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return CCSwipeInteractionController(from: source, to: destination)
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return CCSwipeInteractionController(from: destination, to: source)
    }
}


class CCInteractionInjector: NSObject {
    private enum Edge: Int {
        case top, right, bottom, left
        func toUIRectEdge() -> UIRectEdge {
            let allEdges: [UIRectEdge] = [.top, .right, .bottom, .left]
            return allEdges[self.rawValue]
        }
    }
    
    @IBOutlet weak var targetView: UIView! {
        didSet {
            setup()
        }
    }
    
    @IBInspectable var segueIdentifier: String = ""
    @IBInspectable var isDismiss: Bool = false
    // 0, 1, 2, 3 -> top, right, bottom, left.
    @IBInspectable var edge: Int = Edge.right.rawValue
    private var finalEdge: UIRectEdge {
        return Edge(rawValue: edge)!.toUIRectEdge()
    }
    
    private var recognizer: CCScreenEdgePanGestureRecognizer!
    
    private func setup() {
        recognizer = CCScreenEdgePanGestureRecognizer(target: self, action:#selector(CCInteractionInjector.gestureRecognizerDidUpdate(recognizer:)))
        recognizer.finalEdges = finalEdge
        targetView.addGestureRecognizer(recognizer)
    }
    
    func gestureRecognizerDidUpdate(recognizer: CCScreenEdgePanGestureRecognizer) {
        if recognizer.state == .began {
            if let source = targetView.next as? UIViewController {
                guard source.isViewLoaded else { return }
                guard source.transitionCoordinator == nil else { return }
                if isDismiss {
                    source.dismiss(animated: true, completion: nil)
                } else {
                    source.performSegue(withIdentifier: segueIdentifier, sender: recognizer)
                }
            }
        }
    }
}
