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

public enum Week : TimeUnit {
    
    public static var toTimeIntervalRatio: Double {
        return 604800
    }
    
}

class TimeTests: XCTestCase {
    
    func testSome() {
        let tenMinutes = 10.minutes + 5.seconds
        XCTAssertEqual(tenMinutes.timeInterval, 605)
    }
    
    func testCompare() {
        XCTAssertTrue(10.minutes > 100.seconds)
    }
    
    func testConverted() {
        let tenMinutes = 10.minutes
        XCTAssertEqual(tenMinutes.inSeconds.value, 600)
    }
    
    func testUsage() {
        let tenMinutes = 10.minutes
        let afterTenMinutes = Date() + 10.minutes
        let tenMinutesAndSome = 10.minutes + 15.seconds
        let tenMinutesInSeconds = 10.minutes.inSeconds
        if 10.minutes > 500.seconds {
            print("That's right")
        }
    }
    
}
