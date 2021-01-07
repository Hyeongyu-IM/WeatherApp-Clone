//
//  WeatherPresentable.swift
//  BasicWeatherApp iOS
//
//  Created by 임현규 on 2021/01/03.
//

import Foundation

protocol WeatherPresentable {
    var stateName: String { get }
    var temperatureText: String { get }
    var dateText: String { get }
}
