# Time

This micro-library is made for you if:

- You have ever written something like this:

```swift
let interval: TimeInterval = 10 * 60
```

To represent 10 minutes.

- That's already enough

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

Here `tenMinutes` will actually be of type `TimeInterval<Minute>` (not to be confused with **Foundation**'s `TimeInterval`). There are seven time units available, from nanoseconds to days:

```swift
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
```

#### Operations

You can perform all basic arithmetic operations on time intervals, even of different units:

```swift
let interval = 10.minutes + 15.seconds - 3.minutes + 2.hours // TimeInterval<Minute>
let doubled = interval * 2

let seconds = 10.seconds + 3.minutes // TimeInterval<Second>
```

You can also use these operations on `Date`:

```swift
let oneHourAfter = Date() + 1.hours
```

#### Conversions

Time intervals are easily convertible:

```swift
let twoMinutesInSeconds = 2.minutes.inSeconds // TimeInterval<Second>
```

You can also convert time interval to **Foundation**'s `TimeInterval`, if needed:

```swift
let timeInterval = 5.minutes.timeInterval
```

You can also use `converted(to:)` method:

```swift
let fiveSecondsInHours = 5.seconds.converted(to: Hour.self)
// or
let fiveSecondsInHours: TimeInterval<Hour> = 5.seconds.converted()
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
let fiveWeeks = TimeInterval<Week>(5)
```

For the sake of convenience, don't forget to write those handy extensions:


```swift
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
```

`Time.` prefix is not to confuse the compiler with **Foundation**.

## Disclaimer

**Time** is in very early stage. Some stuff will probably be broken at some point.

## Installation

**Time** is available through [Carthage][carthage-url]. To install, just write into your Cartfile:

```ruby
github "dreymonde/Time" ~> 0.0.1
```

You can also use SwiftPM. Just add to your `Package.swift`:

```swift
import PackageDescription

let package = Package(
    dependencies: [
        .Package(url: "https://github.com/dreymonde/Time.git", majorVersion: 0, minor: 0),
    ]
)
```

[carthage-url]: https://github.com/Carthage/Carthage