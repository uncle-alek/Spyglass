//
//  SpyglassTests.swift
//  SpyglassTests
//
//  Created by Aleksey Yakimenko on 25/7/22.
//

import XCTest
@testable import Spyglass

final class CircularBufferTests: XCTestCase {
    
    private var sut: CircularBuffer<Int>!
    
    override func setUp() {
        super.setUp()
        
        sut = [1, 2, 3]
    }
    
    override func tearDown() {
        sut = nil
        
        super.tearDown()
    }

    func testIndexAfter() {
        XCTAssertEqual(sut.index(after: 0), 1)
        XCTAssertEqual(sut.index(after: 1), 2)
        XCTAssertEqual(sut.index(after: 2), 0)
        XCTAssertEqual(sut.index(after: 7), 2)
    }
    
    func testIndexBefore() {
        XCTAssertEqual(sut.index(before: 0), 2)
        XCTAssertEqual(sut.index(before: 1), 0)
        XCTAssertEqual(sut.index(before: 2), 1)
        XCTAssertEqual(sut.index(before: 7), 0)
    }
}
