//
//  TemperatureUnit.swift
//  BasicWeatherApp iOS
//
//  Created by 임현규 on 2020/12/31.
//

import Foundation

class Temperature {
    
    static let celciusGap = 273.15
    let kelvinValue: Double
    
    init(kelvin: Double) {
        self.kelvinValue = kelvin
    }
    
    var text: String {
        return TemperatureUnit.shared.boolValue ? "\(toCelcius)" : "\(toFahrenheit)"
    }
    
    var toCelcius: Int {
        return Int(kelvinValue - Temperature.celciusGap)
    }
    
    var toFahrenheit: Int {
        let convertedValue = (kelvinValue - 273.15) * 9/5 + 32
        return Int(convertedValue)
    }
}
