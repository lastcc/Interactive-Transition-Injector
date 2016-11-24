//
//  CCPanStoryboardObjects+Recognizer.swift
//  CCInteractiveTransitionInjector
//
//  Created by 陈成 on 2016/11/24.
//  Copyright © 2016年 陈成. All rights reserved.
//

import UIKit

class CCPanGestureRecognizer: UIPanGestureRecognizer {
    var effectingRecognizer: CCPanGestureRecognizer? {
        let effectiveStates: [UIGestureRecognizerState] = [.began, .changed]
        if effectiveStates.contains(state) {
            return self
        }
        return nil
    }
}


class CCPanStoryboardSegue: UIStoryboardSegue, UIViewControllerTransitioningDelegate {
    
    override init(identifier: String?, source: UIViewController, destination: UIViewController) {
        super.init(identifier: identifier, source: source, destination: destination)
        destination.transitioningDelegate = self
        destination.modalPresentationStyle = .fullScreen
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CCPanTransitionAnimator()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CCPanTransitionAnimator()
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return CCPanInteractionController(from: source, to: destination)
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return CCPanInteractionController(from: destination, to: source)
    }
}


class CCPanInteractionInjector: NSObject {
    private enum Direction: Int {
        case left, right, notDetermined = -1
    }
    
    @IBOutlet weak var targetView: UIView! {
        didSet {
            setup()
        }
    }
    
    @IBInspectable var segueIdentifier: String = ""
    private var isDismiss: Bool {
        return segueIdentifier == ""
    }
    // 0, 1 -> left, right.
    @IBInspectable var direction: Int = Direction.left.rawValue
    private var finalDirection: Direction {
        return Direction(rawValue: direction)!
    }
    private var recognizer: CCPanGestureRecognizer!
    
    private func setup() {
        let gestureRecognizers = targetView.gestureRecognizers ?? []
        let results = gestureRecognizers.flatMap { $0 as? CCPanGestureRecognizer }
        recognizer = results.first ?? CCPanGestureRecognizer()
        recognizer.addTarget(self, action: #selector(CCPanInteractionInjector.gestureRecognizerDidUpdate(recognizer:)))
        targetView.addGestureRecognizer(recognizer)
    }
    
    private var recognizerDirection: Direction {
        let translation = recognizer.translation(in: targetView)
        if translation.x > 0 {
            return .right
        } else if translation.x < 0 {
            return .left
        }
        return .notDetermined
    }
    
    private func forceToFailIfNeeded() {
        let translation = recognizer.translation(in: targetView)
        if translation.x == 0 && translation.y != 0 {
            recognizer.isEnabled = false
            recognizer.isEnabled = true
        }
    }
    
    func gestureRecognizerDidUpdate(recognizer: CCPanGestureRecognizer) {
        if recognizer.effectingRecognizer != nil {
            if let source = targetView.next as? UIViewController {
                guard source.isViewLoaded else { return }
                guard source.transitionCoordinator == nil else { return }
                guard recognizerDirection == finalDirection else { return forceToFailIfNeeded() }
                if isDismiss {
                    source.dismiss(animated: true, completion: nil)
                } else {
                    source.performSegue(withIdentifier: segueIdentifier, sender: recognizer)
                }
            }
        }
    }
}
