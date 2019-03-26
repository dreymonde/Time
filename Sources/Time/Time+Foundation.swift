//
//  Time+Foundation.swift
//  Time
//
//  Created by Олег on 03.08.17.
//  Copyright © 2017 Time. All rights reserved.
//

import Foundation

#if os(Linux)
    import Dispatch
#endif

extension Date {
    
    public func addingTimeInterval<Unit>(_ interval: Interval<Unit>) -> Date {
        return addingTimeInterval(interval.timeInterval)
    }
    
    public static func + <Unit>(lhs: Date, rhs: Interval<Unit>) -> Date {
        return lhs.addingTimeInterval(rhs)
    }
    
    public static func - <Unit>(lhs: Date, rhs: Interval<Unit>) -> Date {
        return lhs.addingTimeInterval(-rhs)
    }
    
    public static func += <Unit>(lhs: inout Date, rhs: Interval<Unit>) {
        lhs = lhs + rhs
    }
    
    public static func -= <Unit>(lhs: inout Date, rhs: Interval<Unit>) {
        lhs = lhs - rhs
    }
    
}

extension DispatchQueue {
    #if os(OSX)
        @available(OSXApplicationExtension 10.10, *)
        func asyncAfter<Unit>(after interval: Interval<Unit>, execute item: DispatchWorkItem) {
            self.asyncAfter(deadline: .now() + interval.timeInterval, execute: item)
        }

        @available(OSXApplicationExtension 10.10, *)
        func asyncAfter<Unit>(after interval: Interval<Unit>, qos: DispatchQoS = .default, flags: DispatchWorkItemFlags = [], execute block: @escaping () -> Void) {
            self.asyncAfter(deadline: .now() + interval.timeInterval, qos: qos, flags: flags, execute: block)
        }

    #elseif os(iOS) || os(watchOS) || os(tvOS) || os(Linux)
        func asyncAfter<Unit>(after interval: Interval<Unit>, execute item: DispatchWorkItem) {
            self.asyncAfter(deadline: .now() + interval.timeInterval, execute: item)
        }

        func asyncAfter<Unit>(after interval: Interval<Unit>, qos: DispatchQoS = .default, flags: DispatchWorkItemFlags = [], execute block: @escaping () -> Void) {
            self.asyncAfter(deadline: .now() + interval.timeInterval, qos: qos, flags: flags, execute: block)
        }
    #endif
}
