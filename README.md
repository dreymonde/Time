# Time

This micro-library is made for you if:

- You have ever written something like this:

```swift
let interval: TimeInterval = 10 * 60
```

To represent 10 minutes.

## Usage

#### Showcase

```swift
import Time

let tenMinutes = 10.minutes
let afterTenMinutes = Date() + 10.minutes
let tenMinutesAndSome = 10.minutes + 15.seconds
let tenMinutesInSeconds = 10.minutes.inSeconds
if 10.minutes > 500.seconds {
    print("That's right")
}
```

#### Basics

**Time** is not just a bunch of `Double` conversion functions. The main advantage of it is that all time units are _strongly-typed_. So, for example:

```swift
let tenMinutes = 10.minutes
```

Here `tenMinutes` will actually be of type `Interval<Minute>` (not to be confused with **Foundation**'s `TimeInterval`). There are seven time units available, from nanoseconds to days:

```swift
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
```

#### Operations

You can perform all basic arithmetic operations on time intervals, even of different units:

```swift
let interval = 10.minutes + 15.seconds - 3.minutes + 2.hours // Interval<Minute>
let doubled = interval * 2

let seconds = 10.seconds + 3.minutes // Interval<Second>
```

You can also use these operations on `Date`:

```swift
let oneHourAfter = Date() + 1.hours
```

#### Conversions

Time intervals are easily convertible:

```swift
let twoMinutesInSeconds = 2.minutes.inSeconds // Interval<Second>
```

You can also convert intervals to **Foundation**'s `TimeInterval`, if needed:

```swift
let timeInterval = 5.minutes.timeInterval
```

You can also use `converted(to:)` method:

```swift
let fiveSecondsInHours = 5.seconds.converted(to: Hour.self) // Interval<Hour>
// or
let fiveSecondsInHours: Interval<Hour> = 5.seconds.converted()
```

Although, in my opinion, you would rarely need to.

#### Comparison

You can compare different time units as well

```swift
50.minutes < 1.hour
```

#### Creating your own time units

If, for some reason, you need to create your own time unit, that's super easy to do:

```swift
public enum Week : TimeUnit {
    
    public static var toTimeIntervalRatio: Double {
        return 604800
    }
    
}
```

Now you can use it as any other time unit:

```swift
let fiveWeeks = Interval<Week>(5)
```

For the sake of convenience, don't forget to write those handy extensions:


```swift
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
```

#### Also

Also available:

- Get conversion rate:

```swift
let conversionRate = Hour.conversionRate(to: Second.self) // 3600.0
```

- GCD integration:

```swift
DispatchQueue.main.asyncAfter(after: 5.seconds) {
	// do stuff
}
```

## Disclaimer

**Time** is in very early stage. Some stuff will probably be broken at some point.

## Installation

**Time** is available through [Carthage][carthage-url]. To install, just write into your Cartfile:

```ruby
github "dreymonde/Time" ~> 0.2.0
```

You can also use SwiftPM. Just add to your `Package.swift`:

```swift
import PackageDescription

let package = Package(
    dependencies: [
        .Package(url: "https://github.com/dreymonde/Time.git", majorVersion: 0, minor: 2),
    ]
)
```

[carthage-url]: https://github.com/Carthage/Carthage
