//
//  Time+Foundation.swift
//  Time
//
//  Created by Олег on 03.08.17.
//  Copyright © 2017 Time. All rights reserved.
//

import Foundation

extension Date {
    
    public func addingTimeInterval<Unit : TimeUnit>(_ interval: Interval<Unit>) -> Date {
        return addingTimeInterval(interval.timeInterval)
    }
    
    public static func + <Unit : TimeUnit>(lhs: Date, rhs: Interval<Unit>) -> Date {
        return lhs.addingTimeInterval(rhs)
    }
    
    public static func - <Unit : TimeUnit>(lhs: Date, rhs: Interval<Unit>) -> Date {
        return lhs.addingTimeInterval(-rhs)
    }
    
    public static func += <Unit : TimeUnit>(lhs: inout Date, rhs: Interval<Unit>) {
        lhs = lhs + rhs
    }
    
    public static func -= <Unit : TimeUnit>(lhs: inout Date, rhs: Interval<Unit>) {
        lhs = lhs - rhs
    }
    
}

extension DispatchQueue {
    
    func asyncAfter<Unit : TimeUnit>(after interval: Interval<Unit>, execute item: DispatchWorkItem) {
        self.asyncAfter(deadline: .now() + interval.timeInterval, execute: item)
    }
    
    func asyncAfter<Unit : TimeUnit>(after interval: Interval<Unit>, qos: DispatchQoS = .default, flags: DispatchWorkItemFlags = [], execute block: @escaping () -> Void) {
        self.asyncAfter(deadline: .now() + interval.timeInterval, qos: qos, flags: flags, execute: block)
    }
    
}
