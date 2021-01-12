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
}
    

