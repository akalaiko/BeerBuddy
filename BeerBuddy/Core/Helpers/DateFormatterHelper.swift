//
//  DateFormatterHelper.swift
//  BeerBuddy
//
//  Created by Ke4a on 04.02.2023.
//

import Foundation

protocol DateFormatterProtocol {
    /// Converts timeIntervalSince1970 to string.
    func getString(timeIntervalSince1970 date: Double) -> String
}

final class DateFormatterHelper: DateFormatterProtocol {
    // MARK: - Private Properties

    /// A formatter that converts between dates and their textual representations.
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .long
        formatter.locale = Locale(identifier: "en_US")
        return formatter
    }()
    
    public static let dateFormatterJustHours: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.locale = Locale(identifier: "en_US")
        return formatter
    }()

    /// Application start time.
    private let appStartDate = Date()

    /// Dates cache.
    private var datesTextCache: [Double: String] = [:]

    // MARK: - Public Methods

    /// Getting the date as a string.
    ///
    /// Checks the value in the cache, if there is no value, it converts and writes to the cache. (For future retries)
    /// - Parameter timeIntervalSince1970: Date value initialized relative to 00:00:00 UTC on 1 January 1970.
    /// - Returns:  Date as a string.
    func getString(timeIntervalSince1970 date: Double) -> String {
        let calendar = Calendar.current

        checkingNewDays(calendar)

        guard let dateResult = datesTextCache[date] else {
            return convertToString(calendar, timeIntervalSince1970: date)
        }

        return dateResult
    }

    /// Convert to a string date and write it to the cache.
    ///
    /// - If the date is within 30 seconds of the present time, "now" will be returned.
    /// - If it is today's date,  return the format  "12:00".
    /// - If it is yesterday's date, "Yesterday" will be returned.
    /// - If it is the current day of the week,  return the format  "Feb, 12".
    /// - All other dates return the format "12/01/2023".
    ///
    /// - Parameters:
    ///   - calendar: Calendar.
    ///   - timeIntervalSince1970: Date value initialized relative to 00:00:00 UTC on 1 January 1970.
    /// - Returns: String date value.
    private func convertToString(_ calendar: Calendar, timeIntervalSince1970 date: Double) -> String {
        let currentDay = Date(timeIntervalSince1970: date)

        if let nowTime = calendar.date(byAdding: .second, value: -30, to: Date()),
           nowTime <= currentDay {
            return "now"
        }

        if calendar.isDateInYesterday(currentDay) {
            let stringDate = "yesterday"
            datesTextCache[date] = stringDate
            return stringDate
        }

        if calendar.isDateInToday(currentDay) {
            DateFormatterHelper.dateFormatter.dateFormat = "HH:mm"
        } else if let interval = calendar.dateInterval(of: .weekOfMonth, for: Date()),
                  interval.contains(currentDay) {
            DateFormatterHelper.dateFormatter.dateFormat = "EEE, d"
        } else {
            DateFormatterHelper.dateFormatter.dateStyle = .short
        }

        let stringDate = DateFormatterHelper.dateFormatter.string(from: currentDay)
        datesTextCache[date] = stringDate
        return stringDate
    }

    /// The check is a new day in relation to when the aapplication start time.
    /// If it is a new day, it will clear the cache date.
    ///
    /// - Parameter calendar: Calendar.
    private func checkingNewDays(_ calendar: Calendar) {
        guard calendar.isDateInYesterday(appStartDate) else { return }

        datesTextCache.removeAll()
    }
}
