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
    let regexTextField = RegexTextField()
    let contentTextView = RegexTextView()
    let copyButton: UIButton = {
        var configuration = UIButton.Configuration.tinted()
        configuration.image = UIImage(systemName: "doc.on.doc")
        configuration.title = "Copy pattern"
        configuration.imagePadding = 8.0
        configuration.buttonSize = .large
//        configuration.contentInsets = NSDirectionalEdgeInsets(top: 12.0, leading: 12.0, bottom: 12.0, trailing: 12.0)
        return UIButton(configuration: configuration)
    }()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        title = "Regexy"
        setupStackView()
        setupInputEvents()
        setupCopyAction()
    }
    
    private func setupStackView() {
        view.addSubview(stackView)
        stackView.constraintToFill(useSafeArea: true, horizontalPadding: 20.0)
        stackView.addArrangedSubview(regexTextField)
        stackView.addArrangedSubview(contentTextView)
        stackView.addArrangedSubview(copyButton)
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
            self.showToast(withMessage: "Copied to clipboard")
        }, for: .touchUpInside)
    }
    
    // MARK: - Events
    
    @objc func textFieldDidChangeValue(_ sender: UITextField) {
        regex.setPattern(sender.text)
        updateHighlights()
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
}

// MARK: - UITextViewDelegate

extension RegexViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        updateHighlights()
    }
}
