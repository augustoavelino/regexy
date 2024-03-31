//
//  DSSliderView.swift
//  regexy
//
//  Created by Augusto Avelino on 27/03/24.
//

import UIKit

class DSSliderView: UIControl {
    
    // MARK: Properties
    
    private(set) var steps: Float = 10
    private var ratio: Float { 1 / steps }
    
    var value: Float { slider.value }
    var minimumValue: Float {
        get { slider.minimumValue }
        set { slider.minimumValue = newValue }
    }
    var maximumValue: Float {
        get { slider.maximumValue }
        set { slider.maximumValue = newValue }
    }
    
    // MARK: UI
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 8.0
        return stackView
    }()
    let slider = UISlider()
    let leadingButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "textformat.size.smaller")
        return UIButton(configuration: configuration)
    }()
    let trailingButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "textformat.size.larger")
        return UIButton(configuration: configuration)
    }()
    
    // MARK: - Life cycle
    
    init(steps: Float = 8, initialValue: Float = 0.0) {
        super.init(frame: .zero)
        self.steps = steps
        slider.setValue(initialValue, animated: false)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        backgroundColor = .clear
        setupBackground()
        setupStackView()
        setupEvents()
    }
    
    private func setupBackground() {
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        blurView.layer.cornerRadius = 8.0
        blurView.clipsToBounds = true
        addSubview(blurView)
        blurView.constraintToFill()
    }
    
    private func setupStackView() {
        addSubview(stackView)
        stackView.constraintToFill(horizontalPadding: 12, verticalPadding: 8.0)
        stackView.addArrangedSubview(leadingButton)
        stackView.addArrangedSubview(slider)
        stackView.addArrangedSubview(trailingButton)
        slider.constraint(widthValue: 160)
    }
    
    private func setupEvents() {
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        leadingButton.addTarget(self, action: #selector(didTapLeadingButton), for: .touchUpInside)
        trailingButton.addTarget(self, action: #selector(didTapTrailingButton), for: .touchUpInside)
    }
    
    func setValue(_ value: Float, animated: Bool) {
        slider.setValue(value, animated: animated)
    }
    
    // MARK: - Events
    
    @objc private func sliderValueChanged(_ sender: UISlider) {
        let roundedValue = round(sender.value / ratio) * ratio
        sender.value = roundedValue
        sendActions(for: .valueChanged)
        updateButtonsEnabledState()
    }
    
    @objc private func didTapLeadingButton(_ sender: UIButton) {
        let newValue = max(minimumValue, value - ratio)
        slider.setValue(newValue, animated: true)
        sendActions(for: .valueChanged)
        updateButtonsEnabledState()
    }
    
    @objc private func didTapTrailingButton(_ sender: UIButton) {
        let newValue = min(maximumValue, value + ratio)
        slider.setValue(newValue, animated: true)
        sendActions(for: .valueChanged)
        updateButtonsEnabledState()
    }
    
    private func updateButtonsEnabledState() {
        leadingButton.isEnabled = value != minimumValue
        trailingButton.isEnabled = value != maximumValue
    }
}
