//
//  CellModel.swift
//  BasicWeatherApp iOS
//
//  Created by 임현규 on 2020/12/17.
//

import UIKit

struct WeekendCell {
    let weekend: String
    let icon: String?
    let minCTemp: String
    let maxCTemp: String
    let percent: String?
}

struct HourCell {
    let dt: Int
    let time: String
    let icon: String
    let Ctemp: String
}

struct DetailCell {
    let sunrise: String
    let sunset: String
    let snow: String?
    let humidity: String
    let wind: String
    let feelsLike: String
    let rain: String?
    let pressure: String
    let visibility: String
    let uvi: String
}

struct HeaderCell  {
    let state: String
    let description: String
    let currentTemp: String
    let minTemp: String
    let maxTemp: String
}

struct DetailDescription  {
    let detailDiscription: String
}

struct WeatherListViewCell {
    let time: String
    let state: String
    let currentTempC: String
    let backgrounTime: String
}

