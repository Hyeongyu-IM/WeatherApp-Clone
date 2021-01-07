//
//  Date.swift
//  BasicWeatherApp iOS
//
//  Created by 임현규 on 2020/12/31.
//

import Foundation

class DateConverter {
    
    func convertDateFromUTC(string: String, timezone: Int) -> Date {
        let utcDate = convertDate(from: string)
        return utcDate.addingTimeInterval(Double(timezone))
    }
    
    private func convertDate(from string: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.date(from: string) ?? Date()
    }
}
    

