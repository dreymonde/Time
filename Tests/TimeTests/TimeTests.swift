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

class TimeTests: XCTestCase {
    
    func testSpectre() {
        testTime()
        testExtensions()
        let result = globalContext.run(reporter: StandardReporter())
        XCTAssertTrue(result)
    }
    
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
    
    func testConversionRate() {
        let conversionRate = Hour.conversionRate(to: Second.self)
        XCTAssertEqual(conversionRate, 3600.0)
    }
    
    func testUsage() {
        let tenMinutes = 10.minutes
        let afterTenMinutes = Date() + 10.minutes
        let tenMinutesAndSome = 10.minutes + 15.seconds
        let tenMinutesInSeconds = 10.minutes.inSeconds
        if 10.minutes > 500.seconds {
            print("That's right")
        }
        XCTAssertEqual(tenMinutes.timeInterval, 600)
        XCTAssertGreaterThan(afterTenMinutes, Date())
        XCTAssertEqual(tenMinutesAndSome.timeInterval, 615)
        XCTAssertEqual(tenMinutesInSeconds.value, 600)
        
        print(3.hours.inSeconds)
    }
    
    func testRelative() {
        let afterTenMinutes = Date() + 10.minutes
        let fromNow = 10.minutes.fromNow
        let fromNowDifference = afterTenMinutes.timeIntervalSince(fromNow)
        XCTAssertEqual(fromNowDifference, 0, accuracy: 0.1)
        
        let beforeTenMinutes = Date() - 10.minutes
        let ago = 10.minutes.ago
        let agoDifference = beforeTenMinutes.timeIntervalSince(ago)
        XCTAssertEqual(agoDifference, 0, accuracy: 0.1)
    }
    
    static let allTests = [
        ("testSome", testSome),
        ("testCompare", testCompare),
        ("testConverted", testConverted),
        ("testConversionRate", testConversionRate),
        ("testUsage", testUsage),
        ("testRelative", testRelative)
    ]
}

let tenMinutes = Interval<Minute>(10)

public enum Week : TimeUnit {
    
    public static var toTimeIntervalRatio: Double {
        return 604800
    }
    
}

extension Interval {
    
    public var inWeeks: Interval<Week> {
        return converted()
    }
    
}

extension Double {
    
    public var weeks: Interval<Week> {
        return Interval<Week>(self)
    }
    
}

extension Int {
    
    public var weeks: Interval<Week> {
        return Interval<Week>(Double(self))
    }
    
}
