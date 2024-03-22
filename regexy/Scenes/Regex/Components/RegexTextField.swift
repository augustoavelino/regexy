//
//  RegexTextField.swift
//  regexy
//
//  Created by Augusto Avelino on 20/03/24.
//

import UIKit

class RegexTextField: UITextField {
    
    // MARK: Life cycle
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.insetBy(dx: -6, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.insetBy(dx: -6, dy: 0)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        borderStyle = .roundedRect
        autocapitalizationType = .none
        autocorrectionType = .no
        leftViewMode = .always
        leftView = makeAccessoryLabel(withText: "/")
        rightViewMode = .always
        rightView = makeAccessoryLabel(withText: "/g")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeAccessoryLabel(withText labelText: String?) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.widthAnchor.constraint(equalToConstant: 26).isActive = true
        label.textAlignment = .center
        label.textColor = .lightGray
        label.text = labelText
        return label
    }
}
