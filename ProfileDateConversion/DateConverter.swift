//
//  DateConverterCache.swift
//  ProfileDateConversion
//
//  Created by Worik on 10/09/20.
//  Copyright © 2020 B52-Waitati. All rights reserved.
//

import Foundation
enum DateConverterError {
    case InvalidString
}
class DateConverter {
    
    // Store dates calculated from strings
    var cache = Dictionary<String, Date>()
    var dateFormatter = DateFormatter()
    var calendar = Calendar.current
    init() {
        self.calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        self.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        self.dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)!  
    }
    func clearCache() {
        self.cache.removeAll()
    }
    func convert_yyyy_MM_dd_HH_mm_ss(input: String, cache:Bool = true) -> Date {
        // Input string is of format: yyyy-MM-dd HH:mm:ss
        if cache {
            if let ret = self.cache[input] {
                return ret
            }
        }
        let date = dateFormatter.date(from:input)!
        let components =
            calendar.dateComponents([.year, .month, .day, .hour],
                                                 from: date)
        let ret = calendar.date(from:components)!
        if cache {
            self.cache[input] = ret
        }
        return ret
    }
    /*
     can you write a function that takes a Date and returns dd MMM yyyy. where the day has the "st" and 'nd' and 'rd' postpended to the dd. 
     */
    static let shortMonthSymbols = [
        0:"Jan",
        1:"Feb",
        2:"Mar",
        3:"Apr",
        4:"May",
        5:"Jun",
        6:"Jul",
        7:"Aug",
        8:"Sep",
        9:"Oct",
        10:"Nov",
        11:"Dec"]
    static func prettyDateString(_ date:Date) -> String{
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        let day = calendar.component(.day,from: date)
        let month = calendar.component(.month,from: date)
        let year = calendar.component(.year,from: date)

        var dayString = "\(day)"
        switch day  {
        case 1, 21, 31:
            dayString += "st"
        case 2, 22:
            dayString += "nd"
        case 3,23:
            dayString += "rd"
        default:
            dayString += "th"
        }
        
        return "\(dayString) \(shortMonthSymbols[month]) \(year)"
    }
}
