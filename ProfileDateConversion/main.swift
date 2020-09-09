//
//  main.swift
//  ProfileDateConversion
//
//  Created by Worik on 10/09/20.
//  Copyright © 2020 B52-Waitati. All rights reserved.
//

import Foundation
let count = 200000 // Number of dates to trial
var datesStringString = [(String, String)]() // ("YYYY-MM-DD", "HH")
var datesDate = [Date]() // Store original dates to check conversion


func makeDatesStringString(count:UInt) -> [(String,String)] {
    var ret = [(String, String)]()
    var date = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .none
    var calendar = Calendar.current
    calendar.timeZone = TimeZone(secondsFromGMT: 0)!
    for _ in 1...count {
        let hour:Int = calendar.component(.hour, from: date)
        let year:Int = calendar.component(.year, from: date)
        let month:Int = calendar.component(.month, from: date)
        let day:Int = calendar.component(.day, from: date)
        let ymd = String(format: "%04d-%02d-%02d", year, month, day)
        let hh = String(format: "%02d", hour)
        ret.append((ymd, hh))
        date += 24*6*60
    }
    return ret
}
datesStringString = makeDatesStringString(count: UInt(count))

// Naive conversion.  A new calendar, and DateFormatter for each input
func stringToDateNaive(input:(String,String)) -> Date {
    let ymd = input.0
    let hh = input.1
    let isoDate = "\(ymd)T\(hh):00:00+0000"
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    dateFormatter.locale =
        Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
    let date = dateFormatter.date(from:isoDate)!
    var calendar = Calendar.current
    calendar.timeZone = TimeZone(secondsFromGMT: 0)!
    let components = calendar.dateComponents([.year, .month, .day, .hour], from: date)

    return calendar.date(from:components)!
}
var elapsed: Double
var startDate = Date()
for ss in datesStringString {
    _ = stringToDateNaive(input: ss)
}
elapsed = Date().timeIntervalSince(startDate)
let nRecords = datesStringString.count
print("Naive conversion: " + String(format: "%0.3f", elapsed) +
    " seconds for \(nRecords) dates")
print(String(format: "%0.3f", Double(nRecords)/elapsed)+" dates a second")

let dateFormatter = DateFormatter()
dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
dateFormatter.locale =
    Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
var calendar = Calendar.current
calendar.timeZone = TimeZone(secondsFromGMT: 0)!
func stringToDateLessNaive(input:(String,String)) -> Date {
    let ymd = input.0
    let hh = input.1
    let isoDate = "\(ymd)T\(hh):00:00+0000"
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    dateFormatter.locale =
        Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
    let date = dateFormatter.date(from:isoDate)!
    let components = calendar.dateComponents([.year, .month, .day, .hour], from: date)

    return calendar.date(from:components)!
}
print()
startDate = Date()
for ss in datesStringString {
    _ = stringToDateLessNaive(input: ss)
}
elapsed = Date().timeIntervalSince(startDate)
print("Less Naive conversion: " + String(format: "%0.3f", elapsed) +
    " seconds for \(nRecords) dates")
print(String(format: "%0.3f", Double(nRecords)/elapsed)+" dates a second")


