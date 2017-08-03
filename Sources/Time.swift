//
//  Time.swift
//  Time
//
//  Created by Oleg Dreyman on 03.08.17.
//  Copyright © 2017 Time. All rights reserved.
//

import Foundation

public protocol TimeUnit : Comparable {
    
    init(_ units: Double)
    
    var value: Double { get }
    
    static var toTimeIntervalRatio: Double { get }
    
}

extension TimeUnit {
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.value == rhs.value
    }
    
    public static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.timeInterval < rhs.timeInterval
    }
    
}

extension TimeUnit {
    
    public init(timeInterval: TimeInterval) {
        let units = timeInterval / Self.toTimeIntervalRatio
        self.init(units)
    }
    
    public var timeInterval: TimeInterval {
        return value * Self.toTimeIntervalRatio
    }
    
}

public struct Day : TimeUnit {
    
    public static var toTimeIntervalRatio: Double {
        return 86400
    }
    
    public var value: Double
    
    public init(_ minutes: Double) {
        self.value = minutes
    }
    
}

public struct Hour : TimeUnit {
    
    public static var toTimeIntervalRatio: Double {
        return 3600
    }
    
    public var value: Double
    
    public init(_ minutes: Double) {
        self.value = minutes
    }
    
}

public struct Minute : TimeUnit {
    
    public static var toTimeIntervalRatio: Double {
        return 60
    }
    
    public var value: Double
    
    public init(_ minutes: Double) {
        self.value = minutes
    }
    
}

public struct Second : TimeUnit {
    
    public static var toTimeIntervalRatio: Double {
        return 1
    }
    
    public var value: Double
    
    public init(_ seconds: Double) {
        self.value = seconds
    }
    
}

public struct Millisecond : TimeUnit {
    
    public static var toTimeIntervalRatio: Double {
        return 0.001
    }
    
    public var value: Double
    
    public init(_ seconds: Double) {
        self.value = seconds
    }
    
}

public struct Microsecond : TimeUnit {
    
    public static var toTimeIntervalRatio: Double {
        return 0.000001
    }
    
    public var value: Double
    
    public init(_ seconds: Double) {
        self.value = seconds
    }
    
}

public struct Nanosecond : TimeUnit {
    
    public static var toTimeIntervalRatio: Double {
        return 1e-9
    }
    
    public var value: Double
    
    public init(_ seconds: Double) {
        self.value = seconds
    }
    
}


public extension TimeUnit {
    
    var inSeconds: Second {
        return Second(timeInterval: self.timeInterval)
    }
    
    var inMinutes: Minute {
        return Minute(timeInterval: self.timeInterval)
    }
    
    var inMilliseconds: Millisecond {
        return Millisecond(timeInterval: self.timeInterval)
    }
    
    var inMicroseconds: Microsecond {
        return Microsecond(timeInterval: self.timeInterval)
    }
    
    var inNanoseconds: Nanosecond {
        return Nanosecond(timeInterval: self.timeInterval)
    }
    
    var inHours: Hour {
        return Hour(timeInterval: self.timeInterval)
    }
    
    var inDays: Day {
        return Day(timeInterval: self.timeInterval)
    }
    
}

public extension Double {
    
    var seconds: Second {
        return Second(self)
    }
    
    var minutes: Minute {
        return Minute(self)
    }
    
    var milliseconds: Millisecond {
        return Millisecond(self)
    }
    
    var microseconds: Microsecond {
        return Microsecond(self)
    }
    
    var nanoseconds: Nanosecond {
        return Nanosecond(self)
    }
    
    var hours: Hour {
        return Hour(self)
    }
    
    var days: Day {
        return Day(self)
    }
    
}

public extension Int {
    
    var seconds: Second {
        return Second(Double(self))
    }
    
    var minutes: Minute {
        return Minute(Double(self))
    }
    
    var milliseconds: Millisecond {
        return Millisecond(Double(self))
    }
    
    var microseconds: Microsecond {
        return Microsecond(Double(self))
    }
    
    var nanoseconds: Nanosecond {
        return Nanosecond(Double(self))
    }
    
    var hours: Hour {
        return Hour(Double(self))
    }
    
    var days: Day {
        return Day(Double(self))
    }
    
}

public extension TimeUnit {
    
    static func + <OtherUnit : TimeUnit>(lhs: Self, rhs: OtherUnit) -> Self {
        let inInterval = lhs.timeInterval + rhs.timeInterval
        return Self(timeInterval: inInterval)
    }
    
    static func - <OtherUnit : TimeUnit>(lhs: Self, rhs: OtherUnit) -> Self {
        let inInterval = lhs.timeInterval - rhs.timeInterval
        return Self(timeInterval: inInterval)
    }
    
    static func += <OtherUnit : TimeUnit>(lhs: inout Self, rhs: OtherUnit) {
        lhs = lhs + rhs
    }
    
    static func -= <OtherUnit : TimeUnit>(lhs: inout Self, rhs: OtherUnit) {
        lhs = lhs - rhs
    }
    
    static func * (lhs: Self, rhs: Double) -> Self {
        return Self(lhs.value * rhs)
    }
    
    static func / (lhs: Self, rhs: Double) -> Self {
        return Self(lhs.value / rhs)
    }
    
    static prefix func - (lhs: Self) -> Self {
        return Self(-lhs.value)
    }
    
}

public extension Date {
    
    static func + <Unit : TimeUnit>(lhs: Date, rhs: Unit) -> Date {
        return lhs.addingTimeInterval(rhs.timeInterval)
    }
    
    static func - <Unit : TimeUnit>(lhs: Date, rhs: Unit) -> Date {
        return lhs.addingTimeInterval(-rhs.timeInterval)
    }
    
}
