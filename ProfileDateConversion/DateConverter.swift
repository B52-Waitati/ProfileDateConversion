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
        //self.calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        self.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        self.dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)!   // TODO Time zones out of wack
    }
    func convert_yyyy_MM_dd_HH_mm_ss(input: String, cache:Bool = true) -> Date {
        // Input string is of format: YYYY-MM-dd HH:mm:ss
        if cache {
            if let ret = self.cache[input] {
                return ret
            }
        }
        let date = dateFormatter.date(from:input)!
        //self.calendar.timeZone = TimeZone(secondsFromGMT: 0)! // TODO Time zones out of wack
        var components = calendar.dateComponents([.year, .month, .day, .hour],
                                                 from: date)
        //components.timeZone = TimeZone(secondsFromGMT: 0)// TODO Time zones out of wack
        
        // TODO  Why is this time out by a constant amount
        // TODO Time zones out of wack
        let ret = calendar.date(from:components)!
        if cache {
            self.cache[input] = ret
        }
        return ret
    }
}
