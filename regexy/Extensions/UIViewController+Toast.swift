//
//  UIViewController+Toast.swift
//  regexy
//
//  Created by Augusto Avelino on 21/03/24.
//

import UIKit

extension UIViewController {
    func showToast(withMessage message: String, duration: TimeInterval = 2.0) {
        let toast = makeToast(message)
        view.addSubview(toast)
        let constraints = toast.constraint(centerX: (view.centerXAnchor, 0.0), top: (view.safeAreaLayoutGuide.bottomAnchor, view.safeAreaInsets.bottom))
        view.layoutIfNeeded()
        constraints.top?.constant = -(toast.bounds.height + 16)
        UIView.animate(withDuration: 0.15, delay: 0.0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) { [weak self, weak toast] in
                guard let self = self else { return }
                constraints.top?.constant = self.view.safeAreaInsets.bottom
                UIView.animate(withDuration: 0.15, delay: 0.0, options: .curveEaseIn, animations: {
                    self.view.layoutIfNeeded()
                }) { [weak toast] _ in
                    toast?.removeFromSuperview()
                }
            }
        }
    }
    
    private func makeToast(_ message: String) -> UIView {
        let toastView = UIView()
//        toastView.constraint(heightValue: 36.0)
        let label = UILabel()
        toastView.addSubview(label)
        label.constraintToFill(constant: 8.0)
        label.textAlignment = .center
        label.text = message
        toastView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        toastView.layer.cornerRadius = 8.0
        toastView.clipsToBounds = true
        return toastView
    }
}
