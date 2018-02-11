
import Time
import Foundation

func testExtensions() {
    
    let _1970 = Date(timeIntervalSince1970: 0)
    let refDate = Date(timeIntervalSinceReferenceDate: 0)
    
    describe("date") {
        $0.it("can be added by interval") {
            let fiveSecondsAfter = _1970.addingTimeInterval(5.seconds)
            try expect(fiveSecondsAfter.timeIntervalSince1970) == 5
            let tenMinutesAfter = _1970 + 10.minutes
            try expect(tenMinutesAfter) == _1970.addingTimeInterval(10.minutes)
            var copy = _1970
            copy += 1.hours
            try expect(copy) == Date(timeIntervalSince1970: 60.minutes.timeInterval)
        }
        $0.it("can be subtracted by interval") {
            let fiveSecondsBefore = refDate - 5.seconds
            try expect(fiveSecondsBefore.timeIntervalSinceReferenceDate) == -5
            let tenMinutesBefore = refDate - 10.minutes
            try expect(tenMinutesBefore) == refDate.addingTimeInterval(-10.minutes)
            var copy = refDate
            copy -= 1.hours
            try expect(copy) == Date(timeIntervalSinceReferenceDate: -60.minutes.timeInterval)
        }
    }
    
}
