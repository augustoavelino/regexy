//
//  DSToastView.swift
//  regexy
//
//  Created by Augusto Avelino on 22/03/24.
//

import UIKit

class DSToastView: UIView {
    
    class var animatedConstraintIdentifier: String { "DSToast-Animated-Constraint" }
    
    // MARK: Properties
    
    var message: String? {
        get { label.text }
        set { label.text = newValue }
    }
    
    // MARK: UI
    
    let label = UILabel()
    
    // MARK: - Life cycle
    
    init(_ message: String) {
        super.init(frame: .zero)
        self.message = message
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        setupBackground()
        setupLabel()
    }
    
    private func setupBackground() {
        backgroundColor = UIColor.black.withAlphaComponent(0.5)
        layer.cornerRadius = 8.0
        clipsToBounds = true
    }
    
    private func setupLabel() {
        label.textAlignment = .center
        addSubview(label)
        label.constraintToFill(constant: 8.0)
    }
}
