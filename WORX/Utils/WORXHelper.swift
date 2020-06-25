//
//  CIUWHelper.swift
//  CIUWApp
//
//  Created by Jaelhorton on 5/14/20.
//  Copyright © 2020 ciuw. All rights reserved.
//

import Foundation

class WORXHelper {
    static let sharedInstance = WORXHelper()

    let iso8601DateFormatter = DateFormatter()
    let shortDateFormatter = DateFormatter()
    let halfShortDateFormatter = DateFormatter()
    let time24Formatter = DateFormatter()
    let time12Formatter = DateFormatter()
    let fullTimeDateFormatter = DateFormatter()
    let rfc1123DateFormatter = DateFormatter()
    private init() {
        iso8601DateFormatter.dateFormat = "yyyy-MM-dd"
        shortDateFormatter.dateFormat = "dd/MM/yyyy"
        halfShortDateFormatter.dateFormat = "dd/MM/yy"
        time24Formatter.dateFormat = "HH:mm:ss"
        time12Formatter.dateFormat = "hh:mm a"
        time12Formatter.amSymbol = "AM"
        time12Formatter.pmSymbol = "PM"
        fullTimeDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        rfc1123DateFormatter.dateFormat = "dd MMM yyyy HH:mm"
    }
    
    func getISO8601DateFromString(dateString:String) -> Date? {
        return self.iso8601DateFormatter.date(from: dateString)
    }
    
    func getISO8601DateString(date: Date) -> String{
        return self.iso8601DateFormatter.string(from: date)
    }
    
    func getISO8601DateStringFromShortDateString(date: String) -> String{
        let date = self.getShortDateFromString(dateString: date)
        if let d = date {
            return getISO8601DateString(date: d)
        }
        return ""
    }
    func getISO8601DateStringFromHalfShortDateString(date: String) -> String{
        let date = self.getHalfShortDateFromString(dateString: date)
        if let d = date {
            return getISO8601DateString(date: d)
        }
        return ""
    }
    func getHalfShortDateFromString(dateString:String) -> Date? {
        return self.halfShortDateFormatter.date(from: dateString)
    }

    func getShortDateFromString(dateString:String) -> Date? {
        return self.shortDateFormatter.date(from: dateString)
    }
    
    func getShortDateString(date: Date) -> String{
        return self.shortDateFormatter.string(from: date)
    }
    
    
    func get24HourTimeFromString(timeString: String) -> Date? {
        return self.time24Formatter.date(from: timeString)
    }
    
    func get12HourTimeStringFromDate(time: Date) -> String {
        return self.time12Formatter.string(from: time)
    }
    
    func get12HourTimeStringFromString(timeString: String) -> String{
        let date = self.get24HourTimeFromString(timeString: timeString)
        if let d = date {
            return get12HourTimeStringFromDate(time: d)
        }
        return ""
    }
    
    func get24HourDateTimeFromString(timeString: String) -> Date? {
        return self.fullTimeDateFormatter.date(from: timeString)
    }
    
    func get12HourTimeStringFromFullTimeDate(timeString: String) -> String {
        let date = self.get24HourDateTimeFromString(timeString: timeString)
        if let d = date {
            return get12HourTimeStringFromDate(time: d)
        }
        return ""

    }
    func getRFCDateTimeFromDate(time: Date) -> String{
        return self.rfc1123DateFormatter.string(from: time)
    }
    func getRFCDateTimeFromString(timeString: String) -> String {
        let date = self.get24HourDateTimeFromString(timeString: timeString)
        if let d = date {
            return getRFCDateTimeFromDate(time: d)
        }
        return ""
    }
    func getElapsedInterval(start_date: Date) -> String {

        let interval = Calendar.current.dateComponents([.year, .month, .day], from: start_date, to: Date())

        if let year = interval.year, year > 0 {
            return year == 1 ? "\(year)" + " " + "year ago" :
                "\(year)" + " " + "years ago"
        } else if let month = interval.month, month > 0 {
            return month == 1 ? "\(month)" + " " + "month ago" :
                "\(month)" + " " + "months ago"
        } else if let day = interval.day, day > 0 {
            return day == 1 ? "\(day)" + " " + "day ago" :
                "\(day)" + " " + "days ago"
        } else {
            return "a moment ago"

        }
    }
    func getMatchSize(with size: Int?) -> String {
        switch size {
        case 10:
            return "5 VS 5"
        case 12:
            return "6 VS 6"
        case 14:
            return "7 VS 7"
        case 16:
            return "8 VS 8"
        case 18:
            return "9 VS 9"
        case 20:
            return "10 VS 10"
        case 22:
            return "11 VS 11"
        default:
            return "5 VS 5"
        }
    }
}
