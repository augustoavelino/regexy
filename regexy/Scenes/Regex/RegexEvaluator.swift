//
//  RegexEvaluator.swift
//  regexy
//
//  Created by Augusto Avelino on 21/03/24.
//

import Foundation

class RegexEvaluator {
    private(set) var pattern: String = ""
    
    func setPattern(_ newPattern: String?) {
        pattern = newPattern ?? ""
    }
    
    func matches(in content: String) throws -> [Regex<Regex<AnyRegexOutput>.RegexOutput>.Match] {
        let regex = try Regex(pattern)
        return content.matches(of: regex)
    }
    
    func ranges(in content: String) throws -> [Range<String.Index>] {
        let regex = try Regex(pattern)
        return content.ranges(of: regex)
    }
}
