//
//  TimeTests.swift
//  Time
//
//  Created by Oleg Dreyman on 03.08.17.
//  Copyright © 2017 Time. All rights reserved.
//

import Foundation
import XCTest
import Time

class TimeTests: XCTestCase {
    
    func testSome() {
        let tenMinutes = 10.minutes + 5.seconds
        XCTAssertEqual(tenMinutes.timeInterval, 605)
    }
    
    func testCompare() {
        XCTAssertTrue(10.minutes > 100.seconds)
    }
    
}
