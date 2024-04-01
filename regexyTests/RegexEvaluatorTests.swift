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
    
    func testRegexEvaluatorFindsCorrectMatches() throws {
        let content = "Hello world"
        regex.setPattern("[A-z]\\w+")
        let wordMatches = try regex.matches(in: content)
        XCTAssertEqual(wordMatches.count, 2)
        
        let firstMatch = wordMatches[0]
        let firstWord = String(content[firstMatch.range])
        XCTAssertEqual(firstWord, "Hello")
        
        let secondMatch = wordMatches[1]
        let secondWord = String(content[secondMatch.range])
        XCTAssertEqual(secondWord, "world")
    }
    
    func testRegexEvaluatorFindsRanges() throws {
        regex.setPattern("[A-z]")
        let letterRanges = try regex.ranges(in: "abcdef")
        XCTAssertEqual(letterRanges.count, 6)
    }
    
    func testRegexEvaluatorFindsCorrectRanges() throws {
        let content = "Testing more words now"
        regex.setPattern("[A-z]\\w+")
        let wordRanges = try regex.ranges(in: content)
        XCTAssertEqual(wordRanges.count, 4)
        
        let firstRange = wordRanges[0]
        let firstWord = String(content[firstRange.lowerBound..<firstRange.upperBound])
        XCTAssertEqual(firstWord, "Testing")
        
        let secondRange = wordRanges[1]
        let secondWord = String(content[secondRange.lowerBound..<secondRange.upperBound])
        XCTAssertEqual(secondWord, "more")
        
        let thirdRange = wordRanges[2]
        let thirdWord = String(content[thirdRange.lowerBound..<thirdRange.upperBound])
        XCTAssertEqual(thirdWord, "words")
        
        let fourthRange = wordRanges[3]
        let fourthWord = String(content[fourthRange.lowerBound..<fourthRange.upperBound])
        XCTAssertEqual(fourthWord, "now")
    }
    
    func testRegexEvaluatorThrowsMatchesErrorForWrongPattern() throws {
        regex.setPattern("[A-z")
        XCTAssertThrowsError(try regex.matches(in: "abcdef")) { error in
            XCTAssertEqual((error as NSError).description, "expected ']'")
        }
    }
}
