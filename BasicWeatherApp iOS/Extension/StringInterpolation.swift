//
//  StringInterpolation.swift
//  BasicWeatherApp iOS
//
//  Created by 임현규 on 2020/12/31.
//

import Foundation

extension String.StringInterpolation {
    mutating func appendInterpolation(temperature value: Temperature) {
        appendInterpolation("\(value.text)\(UnitSymbol.forTemperature)")
    }
    
    mutating func appendInterpolation(pressure value: Int) {
        appendInterpolation("\(value) \(UnitSymbol.forPressure)")
    }
    
    mutating func appendInterpolation(wind value: Double) {
        appendInterpolation("\(value) \(UnitSymbol.forWindDegree)")
    }
    
    mutating func appendInterpolation(humidity value: Int) {
        appendInterpolation("\(value) \(UnitSymbol.forHumidity)")
    }
    
    mutating func appendInterpolation(visible value: Int) {
        appendInterpolation("\(value) \(UnitSymbol.forVisible)")
    }
    
    mutating func appendInterpolation(rain value: Double) {
        appendInterpolation("\(value) \(UnitSymbol.forRain)")
    }
    
    mutating func appendInterpolation(forsnow value: Double) {
        appendInterpolation("\(value) \(UnitSymbol.forSnow)")
    }
}

