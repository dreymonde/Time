//
//  TimeTests.swift
//  Time
//
//  Created by Oleg Dreyman on 03.08.17.
//  Copyright © 2017 Time. All rights reserved.
//

import Time
import Foundation
import XCTest

public enum Week : TimeUnit {
    
    public static var toTimeIntervalRatio: Double {
        return 604800
    }
    
}

extension Time.TimeInterval {
    
    public var inWeeks: Time.TimeInterval<Week> {
        return converted()
    }
    
}

extension Double {
    
    public var weeks: Time.TimeInterval<Week> {
        return Time.TimeInterval<Week>(self)
    }
    
}

extension Int {
    
    public var weeks: Time.TimeInterval<Week> {
        return Time.TimeInterval<Week>(Double(self))
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
