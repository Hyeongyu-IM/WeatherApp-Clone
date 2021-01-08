//
//  Date.swift
//  BasicWeatherApp iOS
//
//  Created by 임현규 on 2020/12/31.
//

import Foundation

class DateConverter {
    
    func convertingUTCtime(_ dt: Int) -> Date {
        let timeInterval = TimeInterval(dt)
        let utcTime = Date(timeIntervalSince1970: timeInterval)
        return utcTime
    }
    
//    func convertDateFromUTC(_ utc: String,_ timezone: Int) -> Date {
//        let utcDate = Date(timeIntervalSince1970: TimeInterval(Int(utc)!))
//        return convertDate(from: utcDate)
//    }
//
//    private func convertDate(from date: Date) -> Date {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        formatter.timeZone = TimeZone(secondsFromGMT: timezone)
//        return formatter.date(from: "\(date)") ?? Date()
//    }
}
    

