//
//  Time.swift
//  Time
//
//  Created by Oleg Dreyman on 03.08.17.
//  Copyright © 2017 Time. All rights reserved.
//

import Foundation

public protocol TimeUnit {
    
    static var toTimeIntervalRatio: Double { get }
    
}

public struct TimeInterval<Unit : TimeUnit> {
    
    public var value: Double
    
    public init(_ value: Double) {
        self.value = value
    }
    
    public var timeInterval: Foundation.TimeInterval {
        return value * Unit.toTimeIntervalRatio
    }
    
    public init(timeInterval: Foundation.TimeInterval) {
        let value = timeInterval / Unit.toTimeIntervalRatio
        self.init(value)
    }
    
}

extension TimeInterval : Hashable {
    
    public static func == (lhs: TimeInterval<Unit>, rhs: TimeInterval<Unit>) -> Bool {
        return lhs.value == rhs.value
    }
    
    public static func == <OtherUnit : TimeUnit>(lhs: TimeInterval<Unit>, rhs: TimeInterval<OtherUnit>) -> Bool {
        return lhs == rhs.converted()
    }
    
    public var hashValue: Int {
        return timeInterval.hashValue
    }
    
}

extension TimeInterval {
    
    public static func < (lhs: TimeInterval<Unit>, rhs: TimeInterval<Unit>) -> Bool {
        return lhs.value < rhs.value
    }
    
    public static func <= (lhs: TimeInterval<Unit>, rhs: TimeInterval<Unit>) -> Bool {
        return lhs.value <= rhs.value
    }
    
    public static func > (lhs: TimeInterval<Unit>, rhs: TimeInterval<Unit>) -> Bool {
        return lhs.value >= rhs.value
    }
    
    public static func >= (lhs: TimeInterval<Unit>, rhs: TimeInterval<Unit>) -> Bool {
        return lhs.value >= rhs.value
    }
    
    public static func < <OtherUnit : TimeUnit>(lhs: TimeInterval<Unit>, rhs: TimeInterval<OtherUnit>) -> Bool {
        return lhs < rhs.converted()
    }
    
    public static func <= <OtherUnit : TimeUnit>(lhs: TimeInterval<Unit>, rhs: TimeInterval<OtherUnit>) -> Bool {
        return lhs <= rhs.converted()
    }
    
    public static func > <OtherUnit : TimeUnit>(lhs: TimeInterval<Unit>, rhs: TimeInterval<OtherUnit>) -> Bool {
        return lhs > rhs.converted()
    }
    
    public static func >= <OtherUnit : TimeUnit>(lhs: TimeInterval<Unit>, rhs: TimeInterval<OtherUnit>) -> Bool {
        return lhs >= rhs.converted()
    }
    
}

extension TimeInterval {
    
    public prefix static func - (lhs: TimeInterval<Unit>) -> TimeInterval<Unit> {
        return TimeInterval<Unit>(-lhs.value)
    }
    
    public static func + <OtherUnit : TimeUnit>(lhs: TimeInterval<Unit>, rhs: TimeInterval<OtherUnit>) -> TimeInterval<Unit> {
        let inInterval = lhs.timeInterval + rhs.timeInterval
        return TimeInterval<Unit>(timeInterval: inInterval)
    }
    
    public static func - <OtherUnit : TimeUnit>(lhs: TimeInterval<Unit>, rhs: TimeInterval<OtherUnit>) -> TimeInterval<Unit> {
        return lhs + (-rhs)
    }
    
    static func += <OtherUnit : TimeUnit>(lhs: inout TimeInterval<Unit>, rhs: TimeInterval<OtherUnit>) {
        lhs = lhs + rhs
    }
    
    static func -= <OtherUnit : TimeUnit>(lhs: inout TimeInterval<Unit>, rhs: TimeInterval<OtherUnit>) {
        lhs = lhs - rhs
    }
    
    static func * (lhs: TimeInterval<Unit>, rhs: Double) -> TimeInterval<Unit> {
        return TimeInterval<Unit>(lhs.value * rhs)
    }
    
    static func / (lhs: TimeInterval<Unit>, rhs: Double) -> TimeInterval<Unit> {
        return TimeInterval<Unit>(lhs.value / rhs)
    }
    
}

public struct Day : TimeUnit {
    
    public static var toTimeIntervalRatio: Double {
        return 86400
    }
    
}

public struct Hour : TimeUnit {
    
    public static var toTimeIntervalRatio: Double {
        return 3600
    }
    
}

public struct Minute : TimeUnit {
    
    public static var toTimeIntervalRatio: Double {
        return 60
    }

}

public struct Second : TimeUnit {
    
    public static var toTimeIntervalRatio: Double {
        return 1
    }
    
}

public struct Millisecond : TimeUnit {
    
    public static var toTimeIntervalRatio: Double {
        return 0.001
    }
    
}

public struct Microsecond : TimeUnit {
    
    public static var toTimeIntervalRatio: Double {
        return 0.000001
    }
    
}

public struct Nanosecond : TimeUnit {
    
    public static var toTimeIntervalRatio: Double {
        return 1e-9
    }
    
}

public extension TimeInterval {
    
    var inSeconds: TimeInterval<Second> {
        return TimeInterval<Second>(timeInterval: self.timeInterval)
    }
    
    var inMinutes: TimeInterval<Minute> {
        return TimeInterval<Minute>(timeInterval: self.timeInterval)
    }
    
    var inMilliseconds: TimeInterval<Millisecond> {
        return TimeInterval<Millisecond>(timeInterval: self.timeInterval)
    }
    
    var inMicroseconds: TimeInterval<Microsecond> {
        return TimeInterval<Microsecond>(timeInterval: self.timeInterval)
    }
    
    var inNanoseconds: TimeInterval<Nanosecond> {
        return TimeInterval<Nanosecond>(timeInterval: self.timeInterval)
    }
    
    var inHours: TimeInterval<Hour> {
        return TimeInterval<Hour>(timeInterval: self.timeInterval)
    }
    
    var inDays: TimeInterval<Day> {
        return TimeInterval<Day>(timeInterval: self.timeInterval)
    }
    
    func converted<OtherUnit : TimeUnit>(to otherTimeUnit: OtherUnit.Type = OtherUnit.self) -> TimeInterval<OtherUnit> {
        return TimeInterval<OtherUnit>(timeInterval: self.timeInterval)
    }
    
}

public extension Double {
    
    var seconds: TimeInterval<Second> {
        return TimeInterval<Second>(self)
    }
    
    var minutes: TimeInterval<Minute> {
        return TimeInterval<Minute>(self)
    }
    
    var milliseconds: TimeInterval<Millisecond> {
        return TimeInterval<Millisecond>(self)
    }
    
    var microseconds: TimeInterval<Microsecond> {
        return TimeInterval<Microsecond>(self)
    }
    
    var nanoseconds: TimeInterval<Nanosecond> {
        return TimeInterval<Nanosecond>(self)
    }
    
    var hours: TimeInterval<Hour> {
        return TimeInterval<Hour>(self)
    }
    
    var days: TimeInterval<Day> {
        return TimeInterval<Day>(self)
    }
    
}

public extension Int {
    
    var seconds: TimeInterval<Second> {
        return TimeInterval<Second>(Double(self))
    }
    
    var minutes: TimeInterval<Minute> {
        return TimeInterval<Minute>(Double(self))
    }
    
    var milliseconds: TimeInterval<Millisecond> {
        return TimeInterval<Millisecond>(Double(self))
    }
    
    var microseconds: TimeInterval<Microsecond> {
        return TimeInterval<Microsecond>(Double(self))
    }
    
    var nanoseconds: TimeInterval<Nanosecond> {
        return TimeInterval<Nanosecond>(Double(self))
    }
    
    var hours: TimeInterval<Hour> {
        return TimeInterval<Hour>(Double(self))
    }
    
    var days: TimeInterval<Day> {
        return TimeInterval<Day>(Double(self))
    }
    
}

