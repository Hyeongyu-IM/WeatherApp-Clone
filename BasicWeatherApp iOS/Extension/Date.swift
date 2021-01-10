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
//    // 요일표시 포맷
//    func dtToWeekend() -> String {
//       let dateFormatter = DateFormatter()
//       dateFormatter.dateFormat = "EEEE"
//         dateFormatter.locale = Locale(identifier: "ko-kr")
//       return dateFormatter.string(from: self)
//    }
//
//    // 오전/오후 몇시 표시 포맷
//     func dtToTimeWithLetter() -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "a h시"
//          dateFormatter.locale = Locale(identifier: "ko-kr")
//        return dateFormatter.string(from: self)
//     }
//
//    // 오전/오후 몇시:몇분 포맷
//     func curretTime() -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "a h:m"
//          dateFormatter.locale = Locale(identifier: "ko-kr")
//        return dateFormatter.string(from: self)
//     }
//
//     func timeForBackground() -> Int {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "H"
//          dateFormatter.locale = Locale(identifier: "ko-kr")
//        return Int(dateFormatter.string(from: self))!
//       }
}

 

