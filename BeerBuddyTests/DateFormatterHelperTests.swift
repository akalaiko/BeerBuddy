//
//  DateFormatterHelperTests.swift
//  BeerBuddyTests
//
//  Created by Ke4a on 04.02.2023.
//

@testable import BeerBuddy
import XCTest

extension DateFormatterHelperTests {
    var currentWeek: DateInterval {
        calendar.dateInterval(of: .weekOfMonth, for: nowDate)!
    }

    func checkIsNotYestarday(_ timeIntervalSince1970: Double) -> Bool {
        let date = Date(timeIntervalSince1970: timeIntervalSince1970)
        return !calendar.isDateInYesterday(date)
    }

    func checkIsNotToday(_ timeIntervalSince1970: Double) -> Bool {
        let date = Date(timeIntervalSince1970: timeIntervalSince1970)
        return !calendar.isDateInToday(date)
    }
}

final class DateFormatterHelperTests: XCTestCase {
    var dF: DateFormatterProtocol!
    var calendar: Calendar!
    var nowDate: Date!

    override func setUp() {
        super.setUp()
        dF = DateFormatterHelper()
        calendar = Calendar.current
        nowDate = Date()
    }

    override func tearDown() {
        dF = nil
        calendar = nil
        nowDate = nil
        super.tearDown()
    }

    func testNowDate() {
        let fifteenSecDate = calendar.date(byAdding: .second, value: -15, to: nowDate)!.timeIntervalSince1970
        let overThirtySecDate = calendar.date(byAdding: .second, value: -31, to: nowDate)!.timeIntervalSince1970

        XCTAssertEqual(dF.getString(timeIntervalSince1970: nowDate.timeIntervalSince1970), "now")

        guard checkIsNotYestarday(fifteenSecDate) else { return }
        XCTAssertEqual(dF.getString(timeIntervalSince1970: fifteenSecDate), "now")

        guard checkIsNotYestarday(overThirtySecDate) else { return }
        XCTAssertNotEqual(dF.getString(timeIntervalSince1970: overThirtySecDate), "now")
    }

    func testTimeDate() {
        let date = calendar.date(byAdding: .minute, value: -1, to: nowDate)!.timeIntervalSince1970
        let date2 = calendar.date(byAdding: .minute, value: -15, to: nowDate)!.timeIntervalSince1970

        guard checkIsNotYestarday(date) else { return }
        XCTAssert(dF.getString(timeIntervalSince1970: date).contains(":"))

        guard checkIsNotYestarday(date2) else { return }
        XCTAssert(dF.getString(timeIntervalSince1970: date2).contains(":"))

    }

    func testYesterdayDate() {
        let day = calendar.dateInterval(of: .day, for: nowDate)!

        let yesterday = calendar.date(byAdding: .second, value: -1, to: day.start)!.timeIntervalSince1970
        let yesterday2 = calendar.date(byAdding: .day, value: -1, to: nowDate)!.timeIntervalSince1970

        XCTAssertEqual(dF.getString(timeIntervalSince1970: yesterday), "yesterday")
        XCTAssertEqual(dF.getString(timeIntervalSince1970: yesterday2), "yesterday")
    }

    func testWeekDaysDate() {
        let monday = currentWeek.start.timeIntervalSince1970

        guard checkIsNotToday(monday) && checkIsNotYestarday(monday) else { return }
        XCTAssert( dF.getString(timeIntervalSince1970: monday).contains("Mon"))
    }

    func testDayMonthYearDate() {
        let dayBeforeCurrentWeek = calendar.date(byAdding: .second,
                                                 value: -1,
                                                 to: currentWeek.start)!.timeIntervalSince1970
        let oldDate = calendar.date(byAdding: .second,
                                    value: -15,
                                    to: currentWeek.start)!.timeIntervalSince1970

        XCTAssert(dF.getString(timeIntervalSince1970: dayBeforeCurrentWeek).contains("."))
        XCTAssert(dF.getString(timeIntervalSince1970: oldDate).contains("."))
    }

    func testsFormatSwitching() {
        let nowDate = calendar.date(byAdding: .second, value: -10, to: nowDate)!
        XCTAssertEqual(dF.getString(timeIntervalSince1970: nowDate.timeIntervalSince1970), "now")

        let timeDate = calendar.date(byAdding: .minute, value: -2, to: nowDate)!.timeIntervalSince1970
        if checkIsNotYestarday(timeDate) {
            XCTAssert(dF.getString(timeIntervalSince1970: timeDate).contains(":"))
        }

        let yesterday = calendar.date(byAdding: .day, value: -1, to: nowDate)!.timeIntervalSince1970
        XCTAssertEqual(dF.getString(timeIntervalSince1970: yesterday), "yesterday")

        let monday = currentWeek.start.timeIntervalSince1970
        if checkIsNotToday(monday) && checkIsNotYestarday(monday) {
            XCTAssert(dF.getString(timeIntervalSince1970: monday).contains("Mon"))
        }

        let oldDate = calendar.date(byAdding: .second, value: -1, to: currentWeek.start)
        XCTAssert(dF.getString(timeIntervalSince1970: oldDate!.timeIntervalSince1970).contains("."))
    }
}
