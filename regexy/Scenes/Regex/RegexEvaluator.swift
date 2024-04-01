//
//  RegexEvaluator.swift
//  regexy
//
//  Created by Augusto Avelino on 21/03/24.
//

import Foundation

public class RegexEvaluator {
    private(set) public var pattern: String
    
    public init(pattern: String = "") {
        self.pattern = pattern
    }
    
    public func setPattern(_ newPattern: String?) {
        pattern = newPattern ?? ""
    }
    
    public func matches(in content: String) throws -> [Regex<Regex<AnyRegexOutput>.RegexOutput>.Match] {
        let regex = try Regex(pattern)
        return content.matches(of: regex)
    }
    
    public func ranges(in content: String) throws -> [Range<String.Index>] {
        let regex = try Regex(pattern)
        return content.ranges(of: regex)
    }
}
