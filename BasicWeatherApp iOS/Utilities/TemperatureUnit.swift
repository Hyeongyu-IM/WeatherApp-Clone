//
//  TemperatureUni.swift
//  BasicWeatherApp iOS
//
//  Created by 임현규 on 2020/12/31.
//

import Foundation

class TemperatureUnit {
    enum Unit {
        case celcius, fahrenheit
        
        init(bool: Bool) {
            self = bool ? .celcius : .fahrenheit
        }
    }
static let shared = TemperatureUnit()
    
    var unit: Unit
    
    init() {
        let bool = CoreDataManager.getCurrentTempBool()
        print(bool)
        self.unit = Unit(bool: bool)
    }
    
    init(bool: Bool) {
        self.unit = Unit(bool: bool)
    }
    
    func setUnit(with newValue: Bool) {
        self.unit = Unit(bool: newValue)
    }
    
    var boolValue: Bool {
        return self.unit == .celcius ? true : false
    }

}



