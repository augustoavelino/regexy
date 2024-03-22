//
//  RegexTextView.swift
//  regexy
//
//  Created by Augusto Avelino on 20/03/24.
//

import UIKit

class RegexTextView: UITextView {
    
    // MARK: Life cycle
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        autocorrectionType = .no
        autocapitalizationType = .none
        layer.borderColor = UIColor.darkGray.withAlphaComponent(0.5).cgColor
        layer.borderWidth = 0.5
        layer.cornerRadius = 5.0
        contentInset = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func highlightRanges(_ ranges: [Range<String.Index>]) {
        let attributedContent = NSMutableAttributedString(string: text)
        attributedContent.addAttribute(.foregroundColor, value: UIColor.lightText, range: NSRange(text.startIndex..<text.endIndex, in: text))
        for range in ranges {
            attributedContent.addAttribute(.backgroundColor, value: UIColor.systemIndigo.withAlphaComponent(0.5), range: NSRange(range, in: text))
        }
        attributedText = attributedContent
    }
    
    func clearHighlights() {
        let attributedContent = NSAttributedString(string: text)
        attributedText = attributedContent
    }
}
