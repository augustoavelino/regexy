//
//  UIViewController+Toast.swift
//  regexy
//
//  Created by Augusto Avelino on 21/03/24.
//

import UIKit

extension UIViewController {
    func removeToasts() {
        let toasts = view.subviews.filter({ $0 is DSToastView })
        for toast in toasts {
            toast.removeFromSuperview()
        }
    }
    
    func showToast(withMessage message: String, duration: TimeInterval = 2.0) {
        removeToasts()
        let toast = DSToastView(message)
        prepareToast(toast)
        animateToast(toast) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) { [weak self, weak toast] in
                guard let self = self, let toast = toast else { return }
                self.dismissToast(toast)
            }
        }
    }
    
    func prepareToast(_ toast: DSToastView, completion: (() -> Void)? = nil) {
        view.addSubview(toast)
        let topConstraint = toast.constraint(centerX: (view.centerXAnchor, 0.0), top: (view.safeAreaLayoutGuide.bottomAnchor, view.safeAreaInsets.bottom)).top
        topConstraint?.identifier = DSToastView.animatedConstraintIdentifier
        view.layoutIfNeeded()
    }
    
    func animateToast(_ toast: DSToastView, completion: ((Bool) -> Void)? = nil) {
        animateToastConstraint(toast, constant: -(toast.bounds.height + 16), completion: completion)
    }
    
    func dismissToast(_ toast: DSToastView, completion: ((Bool) -> Void)? = nil) {
        animateToastConstraint(toast, constant: view.safeAreaInsets.bottom) { [weak toast] isComplete in
            toast?.removeFromSuperview()
            completion?(isComplete)
        }
    }
    
    fileprivate func animateToastConstraint(_ toast: DSToastView, constant: CGFloat, completion: ((Bool) -> Void)? = nil) {
        guard view.subviews.contains(toast),
              let topConstraint = getAnimatedToastConstraint() else { return }
        topConstraint.constant = constant
        UIView.animate(withDuration: 0.15, delay: 0.0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: completion)
    }
    
    fileprivate func getAnimatedToastConstraint() -> NSLayoutConstraint? {
        let constraintIdentifier = DSToastView.animatedConstraintIdentifier
        return view.constraints.first(where: { $0.identifier == constraintIdentifier })
    }
}
