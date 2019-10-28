//
//  SlideInPresentationManager.swift
//  MapView
//
//  Created by Elina Lua Ming on 10/26/19.
//  Copyright © 2019 Elina Lua Ming. All rights reserved.
//

import UIKit

enum PresentationDirection {
    case left
    case top
    case right
    case bottom
}

class SlideInPresentationManager: NSObject {
    var direction: PresentationDirection = .bottom
}

extension SlideInPresentationManager: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentationController = SlideInPresentationController(presentedViewController: presented, presenting: presenting, direction: direction)
        return presentationController
    }
    
    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
        ) -> UIViewControllerAnimatedTransitioning? {
        return SlideInPresentationAnimator(direction: direction, isPresentation: true)
    }
    
    func animationController(
        forDismissed dismissed: UIViewController
        ) -> UIViewControllerAnimatedTransitioning? {
        return SlideInPresentationAnimator(direction: direction, isPresentation: false)
    }

}
