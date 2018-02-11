
import Time

enum TwoSeconds : TimeUnit {
    
    static var toTimeIntervalRatio: Double {
        return 2.0
    }
    
}

enum OneSecond : TimeUnit {
    
    static var toTimeIntervalRatio: Double {
        return 1.0
    }
    
}

func testTime() {
    
    describe("interval") {
        let interval = Interval<TwoSeconds>(5.0)
        $0.it("contains a value") {
            try expect(interval.value) == 5.0
        }
        $0.it("can be converted to TimeInterval") {
            let timeInterval = interval.timeInterval
            try expect(timeInterval) == 10.0
        }
        $0.it("can be created from TimeInterval") {
            let interval = Interval<TwoSeconds>(timeInterval: 20.0)
            try expect(interval.value) == 10.0
        }
        $0.it("has a hashValue") {
            let interval = Interval<OneSecond>(10)
            try expect(interval.hashValue) == interval.timeInterval.hashValue
        }
    }
    
    describe("time units") {
        $0.it("can calculate conversion rate") {
            let twoToOne = TwoSeconds.conversionRate(to: OneSecond.self)
            try expect(twoToOne) == 2.0
        }
        $0.it("can be converted") {
            let test2 = Interval<TwoSeconds>(10.0)
            let test1 = test2.converted(to: OneSecond.self)
            try expect(test1.value) == 20.0
        }
        $0.it("can be compared for equality") {
            let test1_1 = Interval<OneSecond>(50)
            let test1_2 = Interval<OneSecond>(50)
            try expect(test1_1) == test1_2
            let test2 = Interval<TwoSeconds>(25)
            try expect(test1_1 == test2) == true
        }
        $0.it("can be compared for inequality") {
            let test1_1 = Interval<OneSecond>(10)
            let test1_2 = Interval<OneSecond>(15)
            try expect(test1_1) != test1_2
            let test2 = Interval<TwoSeconds>(8)
            try expect(test2 != test1_1) == true
        }
        $0.it("can be compared") {
            let seconds50 = Interval<OneSecond>(50)
            let seconds60 = Interval<TwoSeconds>(30)
            try expect(seconds60 < seconds50) == false
            try expect(seconds60 <= seconds50) == false
            try expect(seconds60 > seconds50) == true
            try expect(seconds60 >= seconds50) == true
            let seconds50_2 = Interval<TwoSeconds>(25)
            try expect(seconds50 >= seconds50_2) == true
            try expect(seconds50 <= seconds50_2) == true
        }
        $0.it("can be added") {
            let seconds10 = Interval<OneSecond>(10)
            let seconds30 = Interval<TwoSeconds>(15)
            let seconds40 = seconds10 + seconds30
            try expect(seconds40) == Interval<OneSecond>(40)
            var seconds50 = seconds40
            seconds50 += Interval<OneSecond>(10)
            try expect(seconds50.value) == 50
        }
        $0.it("can be subtracted") {
            let seconds50 = Interval<OneSecond>(50)
            let seconds10 = Interval<TwoSeconds>(5)
            let seconds40 = seconds50 - seconds10
            try expect(seconds40) == Interval(40)
            var seconds20 = seconds40
            seconds20 -= Interval<TwoSeconds>(10)
            try expect(seconds20.value) == 20
            let secondsM20 = -seconds20
            try expect(secondsM20) == Interval(-20)
        }
        $0.it("can be multiplied") {
            let seconds50 = Interval<TwoSeconds>(25)
            let seconds100 = seconds50 * 2
            try expect(seconds100) == Interval(50)
        }
        $0.it("can be divided") {
            let seconds100 = Interval<TwoSeconds>(50)
            let seconds50 = seconds100 / 2
            try expect(seconds50) == Interval(25)
        }
        
        $0.it("day") {
            try expect(Day.toTimeIntervalRatio) == 86400
            try expect(5.seconds.inDays) == 5.seconds.converted(to: Day.self)
            try expect(10.days) == Interval<Day>(10)
            try expect(10.5.days) == Interval<Day>(10.5)
        }
        $0.it("hour") {
            try expect(Hour.toTimeIntervalRatio) == 3600
            try expect(5.seconds.inHours) == 5.seconds.converted(to: Hour.self)
            try expect(3.hours) == Interval<Hour>(3)
            try expect(5.3.hours) == Interval<Hour>(5.3)
        }
        $0.it("minute") {
            try expect(Minute.toTimeIntervalRatio) == 60
            try expect(5.seconds.inMinutes) == 5.seconds.converted(to: Minute.self)
            try expect(5.minutes) == Interval<Minute>(5)
            try expect(2.3.minutes) == Interval<Minute>(2.3)
        }
        $0.it("second") {
            try expect(Second.toTimeIntervalRatio) == 1
            try expect(1.minutes.inSeconds) == 1.minutes.converted(to: Second.self)
            try expect(30.seconds) == Interval<Second>(30)
            try expect(45.5.seconds) == Interval<Second>(45.5)
        }
        $0.it("millisecond") {
            try expect(Millisecond.toTimeIntervalRatio) == 0.001
            try expect(100.seconds.inMilliseconds) == 100.seconds.converted(to: Millisecond.self)
            try expect(1000.milliseconds) == Interval<Millisecond>(1000)
            try expect(343.43.milliseconds) == Interval<Millisecond>(343.43)
        }
        $0.it("microsecond") {
            try expect(Microsecond.toTimeIntervalRatio) == 0.000001
            try expect(2.seconds.inMicroseconds) == 2.seconds.converted(to: Microsecond.self)
            try expect(1000.microseconds) == Interval<Microsecond>(1000)
            try expect(1.5.microseconds) == Interval<Microsecond>(1.5)
        }
        $0.it("nanosecond") {
            try expect(Nanosecond.toTimeIntervalRatio) == 1e-9
            try expect(10.seconds.inNanoseconds) == 10.seconds.converted(to: Nanosecond.self)
            try expect(1000.nanoseconds) == Interval<Nanosecond>(1000)
            try expect(500.1.nanoseconds) == Interval<Nanosecond>(500.1)
        }
        
    }
    
}
