//
//  DSEmptyListView.swift
//  regexy
//
//  Created by Augusto Avelino on 31/03/24.
//

import UIKit

class DSEmptyListView: UIView {
    
    // MARK: Properties
    
    var text: String? {
        get { label.text }
        set { label.text = newValue }
    }
    
    var image: UIImage? {
        get { imageView.image }
        set { imageView.image = newValue }
    }
    
    // MARK: UI
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16.0
        return stackView
    }()
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .secondaryLabel
        return imageView
    }()
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        return label
    }()
    
    // MARK: - Life cycle
    
    init(text: String? = "Empty", image: UIImage? = UIImage(systemName: "tray.fill")) {
        super.init(frame: .zero)
        setupUI()
        self.text = text
        self.image = image
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        setupStackView()
        setupSizes()
    }
    
    private func setupStackView() {
        addSubview(stackView)
        stackView.constraint(
            centerX: (centerXAnchor, 0.0),
            centerY: (centerYAnchor, 0.0))
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(label)
    }
    
    private func setupSizes() {
        imageView.constraint(widthValue: 64.0, heightValue: 64.0)
        label.font = .systemFont(ofSize: 18.0)
    }
}
