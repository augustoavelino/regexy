//
//  RegexEvaluatorTests.swift
//  regexyTests
//
//  Created by Augusto Avelino on 01/04/24.
//

import regexy
import XCTest

final class RegexEvaluatorTests: XCTestCase {
    
    // MARK: Subject
    
    var regex: RegexEvaluator!
    
    // MARK: - Setup
    
    override func setUpWithError() throws {
        regex = RegexEvaluator()
    }
    
    override func tearDownWithError() throws {
        regex = nil
    }
    
    // MARK: - Tests
    
    func testRegexEvaluatorFindsMatches() throws {
        regex.setPattern("[A-z]")
        let letterMatches = try regex.matches(in: "abcdef")
        XCTAssertEqual(letterMatches.count, 6)
    }
    
    func testRegexEvaluatorFindsCorrectRanges() throws {
        let content = "Testing words"
        regex.setPattern("[A-z]\\w+")
        let wordRanges = try regex.ranges(in: content)
        XCTAssertEqual(wordRanges.count, 2)
        
        let firstRange = wordRanges[0]
        let firstWord = String(content[firstRange.lowerBound..<firstRange.upperBound])
        XCTAssertEqual(firstWord, "Testing")
        
        let secondRange = wordRanges[1]
        let secondWord = String(content[secondRange.lowerBound..<secondRange.upperBound])
        XCTAssertEqual(secondWord, "words")
    }
    
    func testRegexEvaluatorFindsRanges() throws {
        regex.setPattern("[A-z]")
        let letterRanges = try regex.ranges(in: "abcdef")
        XCTAssertEqual(letterRanges.count, 6)
    }
    
    func testRegexEvaluatorThrowsMatchesErrorForWrongPattern() throws {
        regex.setPattern("[A-z")
        XCTAssertThrowsError(try regex.matches(in: "abcdef")) { error in
            XCTAssertEqual((error as NSError).description, "expected ']'")
        }
    }
}
