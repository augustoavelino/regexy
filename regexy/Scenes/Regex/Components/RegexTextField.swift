//
//  RegexTextField.swift
//  regexy
//
//  Created by Augusto Avelino on 20/03/24.
//

import UIKit

class RegexTextField: UITextField {
    
    // MARK: UI
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.insetBy(dx: -6.0, dy: 0.0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.insetBy(dx: -6.0, dy: 0.0)
    }
    
    // MARK: - Life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupBehavior()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        borderStyle = .roundedRect
        setupSupplementaryViews()
    }
    
    private func setupBehavior() {
        autocapitalizationType = .none
        autocorrectionType = .no
        returnKeyType = .done
        spellCheckingType = .no
    }
    
    private func setupSupplementaryViews() {
        leftViewMode = .always
        leftView = makeSupplementaryLabel(withText: "/")
        rightViewMode = .always
        rightView = makeSupplementaryLabel(withText: "/g")
    }
    
    // MARK: - Helpers
    
    private func makeSupplementaryLabel(withText labelText: String?) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.widthAnchor.constraint(equalToConstant: 26.0).isActive = true
        label.textAlignment = .center
        label.textColor = .lightGray
        label.text = labelText
        return label
    }
}
