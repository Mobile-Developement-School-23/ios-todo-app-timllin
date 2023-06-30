//
//  CustomTransition.swift
//  toDoList--2023
//
//  Created by Тимур Калимуллин on 30.06.2023.
//

import UIKit

class TransitioninDelegate : NSObject, UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TransitionAnimation(duration: 0.5)
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return  nil
    }
}
