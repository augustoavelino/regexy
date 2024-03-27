//
//  RegexViewController.swift
//  regexy
//
//  Created by Augusto Avelino on 19/03/24.
//

import UIKit
import RegexBuilder

class RegexViewController: UIViewController {
    
    // MARK: Properties
    
    let regex = RegexEvaluator()
    let queue = DispatchQueue(label: "regex_processing")
    var workItem: DispatchWorkItem?
    var content: String { contentTextView.text }
    
    // MARK: UI
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16.0
        return stackView
    }()
    let topStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 8.0
        return stackView
    }()
    let regexTextField = RegexTextField()
    let contentTextView = RegexTextView()
    let copyButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "doc.on.doc")
        configuration.buttonSize = .small
        return UIButton(configuration: configuration)
    }()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        setupNavigationBar()
        setupStackView()
        setupInputEvents()
        setupCopyAction()
    }
    
    private func setupNavigationBar() {
        title = "Regexy"
        navigationItem.setRightBarButtonItems([
            UIBarButtonItem(image: UIImage(systemName: "textformat.size.larger"), style: .plain, target: self, action: #selector(didTapIncreaseFontSize)),
            UIBarButtonItem(image: UIImage(systemName: "textformat.size.smaller"), style: .plain, target: self, action: #selector(didTapDecreaseFontSize)),
        ], animated: false)
    }
    
    private func setupStackView() {
        view.addSubview(stackView)
        stackView.constraintToFill(useSafeArea: true, horizontalPadding: 20.0)
        stackView.addArrangedSubview(topStackView)
        topStackView.addArrangedSubview(regexTextField)
        topStackView.addArrangedSubview(copyButton)
        stackView.addArrangedSubview(contentTextView)
    }
    
    private func setupInputEvents() {
        contentTextView.delegate = self
        regexTextField.addTarget(self, action: #selector(textFieldDidChangeValue), for: .valueChanged)
        regexTextField.addTarget(self, action: #selector(textFieldDidChangeValue), for: .editingChanged)
    }
    
    private func setupCopyAction() {
        copyButton.addAction(UIAction { [weak self] _ in
            guard let self = self else { return }
            UIPasteboard.general.string = self.regexTextField.text
            self.showToast(withMessage: "Copied pattern to clipboard")
        }, for: .touchUpInside)
    }
    
    private func updateHighlights() {
        do {
            let ranges = try regex.ranges(in: content)
            contentTextView.highlightRanges(ranges)
        } catch {
            print("=== MATCH ERROR ===")
            debugPrint(error)
            print()
        }
    }
    
    // MARK: - Events
    
    @objc func textFieldDidChangeValue(_ sender: UITextField) {
        regex.setPattern(sender.text)
        updateHighlights()
    }
    
    @objc func didTapIncreaseFontSize(_ sender: UIBarButtonItem) {
        contentTextView.fontSize += 1
    }
    
    @objc func didTapDecreaseFontSize(_ sender: UIBarButtonItem) {
        contentTextView.fontSize -= 1
    }
}

// MARK: - UITextViewDelegate

extension RegexViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        updateHighlights()
    }
}
