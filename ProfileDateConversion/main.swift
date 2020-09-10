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

var dateConverter = DateConverter()
func randomDate() -> (String, Date) {
    let hour:Int = Int.random(in: 0..<12)
    let year:Int = Int.random(in: 2000...2100)
    let month:Int = Int.random(in: 1...12)
    let day:Int = Int.random(in: 1...28)
    let ymd = String(format: "%04d-%02d-%02d", year, month, day)
    let hh = String(format: "%02d",hour)
    let dstring = String("\(ymd) \(hh):00:00")
    return (dstring,
            dateConverter.convert_yyyy_MM_dd_HH_mm_ss(input: dstring))
}

for _ in 0..<10 {
    let ssDate = randomDate()
    var elapsed: Double
    let startDate = Date()
    for _ in 1...count {
        _ = dateConverter.convert_yyyy_MM_dd_HH_mm_ss(input: ssDate.0)
    }
    elapsed = Date().timeIntervalSince(startDate)
    print("Elapsed time to convert:\n\(ssDate.0) to \n\(ssDate.1.description) " +
        "\n\(count) times is \(elapsed) seconds")
    print(String(format: "%0.3f", Double(count)/elapsed) + " records a second")
}
print("Done")
exit(0)

func makeDatesStringStringNaive(count:UInt) -> [(String,String)] {
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

// Less naive conversion.  A new calendar, and DateFormatter for each input
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
    let date = dateFormatter.date(from:isoDate)!
    let components = calendar.dateComponents([.year, .month, .day, .hour], from: date)
    return calendar.date(from:components)!
}

datesStringString = makeDatesStringStringNaive(count: UInt(count))
var nRecords = datesStringString.count

var elapsed: Double
var startDate = Date()
for ss in datesStringString {
    _ = stringToDateNaive(input: ss)
}
elapsed = Date().timeIntervalSince(startDate)

print("Sequential dates just hours apart.....")
print("Naive conversion: " + String(format: "%0.3f", elapsed) +
    " seconds for \(nRecords) dates")
print(String(format: "%0.3f", Double(nRecords)/elapsed)+" dates a second")

print()
startDate = Date()
for ss in datesStringString {
    _ = stringToDateLessNaive(input: ss)
}
elapsed = Date().timeIntervalSince(startDate)
print("Less Naive conversion: " + String(format: "%0.3f", elapsed) +
    " seconds for \(nRecords) dates")
print(String(format: "%0.3f", Double(nRecords)/elapsed)+" dates a second")

func makeDatesStringStringRandom(count:UInt) -> [(String,String)] {
    var ret = [(String, String)]()
    var date = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .none
    var calendar = Calendar.current
    calendar.timeZone = TimeZone(secondsFromGMT: 0)!
    for _ in 1...count {
        let hour:Int = Int.random(in: 0..<12)
        let year:Int = Int.random(in: 2000...2100)
        let month:Int = Int.random(in: 1...12)
        let day:Int = Int.random(in: 1...28)
        let ymd = String(format: "%04d-%02d-%02d", year, month, day)
        let hh = String(hour)
        ret.append((ymd, String(hh)))
        date += 24*6*60
    }
    return ret
}

datesStringString = makeDatesStringStringRandom(count: UInt(count))
nRecords = datesStringString.count
startDate = Date()
for ss in datesStringString {
    _ = stringToDateNaive(input: ss)
}
elapsed = Date().timeIntervalSince(startDate)
print()
print("Random dates.....")
print("Naive conversion: " + String(format: "%0.3f", elapsed) +
    " seconds for \(nRecords) dates")
print(String(format: "%0.3f", Double(nRecords)/elapsed)+" dates a second")
print()

startDate = Date()
for ss in datesStringString {
    _ = stringToDateLessNaive(input: ss)
}
elapsed = Date().timeIntervalSince(startDate)
print("Less Naive conversion: " + String(format: "%0.3f", elapsed) +
    " seconds for \(nRecords) dates")
print(String(format: "%0.3f", Double(nRecords)/elapsed)+" dates a second")

