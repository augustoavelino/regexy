//
//  RegexTextView.swift
//  regexy
//
//  Created by Augusto Avelino on 20/03/24.
//

import UIKit

class RegexTextView: UITextView {
    
    // MARK: Properties
    
    private(set) var highlightedRanges: [Range<String.Index>] = []
    var fontSize: CGFloat = 16.0 {
        didSet { applyHighlights() }
    }
    
    // MARK: - Life cycle
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setupUI()
        setupBehavior()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        font = .systemFont(ofSize: fontSize)
        contentInset = UIEdgeInsets(top: 0.0, left: 4.0, bottom: 0.0, right: 4.0)
        setupBorder()
        setupToolbar()
    }
    
    private func setupBehavior() {
        keyboardDismissMode = .interactive
        autocapitalizationType = .none
        autocorrectionType = .no
        spellCheckingType = .no
    }
    
    private func setupBorder() {
        layer.borderColor = UIColor.darkGray.withAlphaComponent(0.5).cgColor
        layer.borderWidth = 0.5
        layer.cornerRadius = 5.0
    }
    
    private func setupToolbar() {
        let toolbar = UIToolbar(frame: CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width, height: 44.0)))
        toolbar.setItems([
            .flexibleSpace(),
            UIBarButtonItem(systemItem: .done, primaryAction: UIAction { [weak self] action in
                self?.resignFirstResponder()
            }),
        ], animated: false)
        inputAccessoryView = toolbar
    }
    
    // MARK: - Display changes
    
    func highlightRanges(_ ranges: [Range<String.Index>]) {
        highlightedRanges = ranges
        applyHighlights()
    }
    
    func clearHighlights() {
        let attributedContent = NSAttributedString(string: text)
        attributedText = attributedContent
    }
    
    private func applyHighlights() {
        let attributedContent = makeAttributedContent()
        for range in highlightedRanges {
            attributedContent.addAttribute(.backgroundColor, value: UIColor.systemIndigo.withAlphaComponent(0.5), range: NSRange(range, in: text))
        }
        attributedText = attributedContent
    }
    
    // MARK: - Helpers
    
    private func makeAttributedContent() -> NSMutableAttributedString {
        let attributedContent = NSMutableAttributedString(string: text)
        attributedContent.addAttributes([
            .foregroundColor: UIColor.label,
            .font: UIFont.systemFont(ofSize: fontSize)
        ], range: NSRange(text.startIndex..<text.endIndex, in: text))
        return attributedContent
    }
}
