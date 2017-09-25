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

public struct Interval<Unit : TimeUnit> {
    
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

extension Interval : Hashable {
    
    public static func == (lhs: Interval<Unit>, rhs: Interval<Unit>) -> Bool {
        return lhs.value == rhs.value
    }
    
    public static func == <OtherUnit>(lhs: Interval<Unit>, rhs: Interval<OtherUnit>) -> Bool {
        return lhs == rhs.converted()
    }
    
    public static func != <OtherUnit>(lhs: Interval<Unit>, rhs: Interval<OtherUnit>) -> Bool {
        return lhs != rhs.converted()
    }
    
    public var hashValue: Int {
        return timeInterval.hashValue
    }
    
}

extension Interval {
    
    public static func < (lhs: Interval<Unit>, rhs: Interval<Unit>) -> Bool {
        return lhs.value < rhs.value
    }
    
    public static func <= (lhs: Interval<Unit>, rhs: Interval<Unit>) -> Bool {
        return lhs.value <= rhs.value
    }
    
    public static func > (lhs: Interval<Unit>, rhs: Interval<Unit>) -> Bool {
        return lhs.value >= rhs.value
    }
    
    public static func >= (lhs: Interval<Unit>, rhs: Interval<Unit>) -> Bool {
        return lhs.value >= rhs.value
    }
    
    public static func < <OtherUnit>(lhs: Interval<Unit>, rhs: Interval<OtherUnit>) -> Bool {
        return lhs < rhs.converted()
    }
    
    public static func <= <OtherUnit>(lhs: Interval<Unit>, rhs: Interval<OtherUnit>) -> Bool {
        return lhs <= rhs.converted()
    }
    
    public static func > <OtherUnit>(lhs: Interval<Unit>, rhs: Interval<OtherUnit>) -> Bool {
        return lhs > rhs.converted()
    }
    
    public static func >= <OtherUnit>(lhs: Interval<Unit>, rhs: Interval<OtherUnit>) -> Bool {
        return lhs >= rhs.converted()
    }
    
}

extension Interval {
    
    public prefix static func - (lhs: Interval<Unit>) -> Interval<Unit> {
        return Interval<Unit>(-lhs.value)
    }
    
    public static func + <OtherUnit>(lhs: Interval<Unit>, rhs: Interval<OtherUnit>) -> Interval<Unit> {
        let inInterval = lhs.timeInterval + rhs.timeInterval
        return Interval<Unit>(timeInterval: inInterval)
    }
    
    public static func - <OtherUnit>(lhs: Interval<Unit>, rhs: Interval<OtherUnit>) -> Interval<Unit> {
        return lhs + (-rhs)
    }
    
    public static func += <OtherUnit>(lhs: inout Interval<Unit>, rhs: Interval<OtherUnit>) {
        lhs = lhs + rhs
    }
    
    public static func -= <OtherUnit>(lhs: inout Interval<Unit>, rhs: Interval<OtherUnit>) {
        lhs = lhs - rhs
    }
    
    public static func * (lhs: Interval<Unit>, rhs: Double) -> Interval<Unit> {
        return Interval<Unit>(lhs.value * rhs)
    }
    
    public static func / (lhs: Interval<Unit>, rhs: Double) -> Interval<Unit> {
        return Interval<Unit>(lhs.value / rhs)
    }
    
}

public enum Day : TimeUnit {
    
    public static var toTimeIntervalRatio: Double {
        return 86400
    }
    
}

public enum Hour : TimeUnit {
    
    public static var toTimeIntervalRatio: Double {
        return 3600
    }
    
}

public enum Minute : TimeUnit {
    
    public static var toTimeIntervalRatio: Double {
        return 60
    }

}

public enum Second : TimeUnit {
    
    public static var toTimeIntervalRatio: Double {
        return 1
    }
    
}

public enum Millisecond : TimeUnit {
    
    public static var toTimeIntervalRatio: Double {
        return 0.001
    }
    
}

public enum Microsecond : TimeUnit {
    
    public static var toTimeIntervalRatio: Double {
        return 0.000001
    }
    
}

public enum Nanosecond : TimeUnit {
    
    public static var toTimeIntervalRatio: Double {
        return 1e-9
    }
    
}

extension TimeUnit {
    
    public static func conversionRate<OtherUnit : TimeUnit>(to otherTimeUnit: OtherUnit.Type) -> Double {
        return Self.toTimeIntervalRatio / OtherUnit.toTimeIntervalRatio
    }
    
}

public extension Interval {
    
    var inSeconds: Interval<Second> {
        return converted()
    }
    
    var inMinutes: Interval<Minute> {
        return converted()
    }
    
    var inMilliseconds: Interval<Millisecond> {
        return converted()
    }
    
    var inMicroseconds: Interval<Microsecond> {
        return converted()
    }
    
    var inNanoseconds: Interval<Nanosecond> {
        return converted()
    }
    
    var inHours: Interval<Hour> {
        return converted()
    }
    
    var inDays: Interval<Day> {
        return converted()
    }
    
    func converted<OtherUnit : TimeUnit>(to otherTimeUnit: OtherUnit.Type = OtherUnit.self) -> Interval<OtherUnit> {
        return Interval<OtherUnit>(self.value * Unit.conversionRate(to: otherTimeUnit))
    }
    
}

public extension Double {
    
    var seconds: Interval<Second> {
        return Interval<Second>(self)
    }
    
    var minutes: Interval<Minute> {
        return Interval<Minute>(self)
    }
    
    var milliseconds: Interval<Millisecond> {
        return Interval<Millisecond>(self)
    }
    
    var microseconds: Interval<Microsecond> {
        return Interval<Microsecond>(self)
    }
    
    var nanoseconds: Interval<Nanosecond> {
        return Interval<Nanosecond>(self)
    }
    
    var hours: Interval<Hour> {
        return Interval<Hour>(self)
    }
    
    var days: Interval<Day> {
        return Interval<Day>(self)
    }
    
}

public extension Int {
    
    var seconds: Interval<Second> {
        return Interval<Second>(Double(self))
    }
    
    var minutes: Interval<Minute> {
        return Interval<Minute>(Double(self))
    }
    
    var milliseconds: Interval<Millisecond> {
        return Interval<Millisecond>(Double(self))
    }
    
    var microseconds: Interval<Microsecond> {
        return Interval<Microsecond>(Double(self))
    }
    
    var nanoseconds: Interval<Nanosecond> {
        return Interval<Nanosecond>(Double(self))
    }
    
    var hours: Interval<Hour> {
        return Interval<Hour>(Double(self))
    }
    
    var days: Interval<Day> {
        return Interval<Day>(Double(self))
    }
    
}
