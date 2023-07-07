//
//  TransitionManager.swift
//  toDoList--2023
//
//  Created by Тимур Калимуллин on 30.06.2023.
//

import UIKit

final class TransitionAnimation: NSObject, UIViewControllerAnimatedTransitioning {

    private let duration: TimeInterval

    init(duration: TimeInterval) {
        self.duration = duration
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to),
              let fromViewController = transitionContext.viewController(forKey: .from)
        else {
            transitionContext.completeTransition(false)
            return }

        guard let toViewController = toViewController as? TodoItemViewController,
              let fromViewController = fromViewController.children.first as? MainViewController, let cell = fromViewController.getCell(),
              let snapshot = toViewController.view.snapshotView(afterScreenUpdates: true) else {  return }

        let vContainer = transitionContext.containerView
        toViewController.view.isHidden = true
        vContainer.addSubview(toViewController.view)

        snapshot.frame = vContainer.convert(cell.contentView.frame, from: cell)
        vContainer.addSubview(snapshot)

        UIView.animate(withDuration: duration, animations: {
                    snapshot.frame = (transitionContext.finalFrame(for: toViewController))
                }, completion: { _ in
                    toViewController.view.isHidden = false
                    snapshot.removeFromSuperview()
                    transitionContext.completeTransition(true)
        })
    }
}
