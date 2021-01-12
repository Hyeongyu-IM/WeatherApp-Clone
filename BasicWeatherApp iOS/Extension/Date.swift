//
//  Date.swift
//  BasicWeatherApp iOS
//
//  Created by 임현규 on 2021/01/07.
//

import Foundation

extension Date {
    func dtToWeekend(_ timezone: Int ) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: timezone)
        dateFormatter.locale = Locale(identifier: "ko-kr")
        return dateFormatter.string(from: self)
    }
    
    func dtToTimeWithLetter(_ timezone: Int ) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "a h시"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: timezone)
        dateFormatter.locale = Locale(identifier: "ko-kr")
        return dateFormatter.string(from: self)
    }
    
    func curretTime(_ timezone: Int ) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "a h:mm"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: timezone)
        dateFormatter.locale = Locale(identifier: "ko-kr")
        return dateFormatter.string(from: self)
    }
    
    func timeForBackground(_ timezone: Int ) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: timezone)
        dateFormatter.locale = Locale(identifier: "ko-kr")
        return dateFormatter.string(from: self)
    }
}

 

