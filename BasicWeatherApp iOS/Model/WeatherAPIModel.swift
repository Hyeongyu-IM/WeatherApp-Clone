//
//  wheatherModel.swift
//  BasicWeatherApp iOS
//
//  Created by 임현규 on 2020/12/07.
//

import UIKit

struct WeatherInfo: Codable {
    let lat: Double
    let lon: Double
    var timezone: String
    let timezone_offset: Int
    let current: CurrentWeatherInfo
    let hourly: [HourlyWeatherInfo]
    let daily: [DailyWeatherInfo]
}

struct CurrentWeatherInfo: Codable {
    let dt: Int
    let sunrise: Int
    let sunset: Int
    let temp: Double
    let pressure: Int
    let humidity: Int
    let visibility: Int
    let wind_deg: Int
    let uvi: Double
    let wind_speed: Double
    let feels_like: Double
    let rain: Rain?
    let snow: Snow?
    let weather: [TitleWeatherInfo]
}

struct DailyWeatherInfo: Codable {
    let dt: Int
    let sunrise: Int
    let sunset: Int
    let temp: DailyTemp
    let weather: [TitleWeatherInfo]
}

struct HourlyWeatherInfo: Codable {
    let dt: Int
    let temp: Double
    let weather: [TitleWeatherInfo]
}

struct TitleWeatherInfo: Codable {
    let description: String
    let icon: String
}

struct DailyTemp: Codable {
    let max: Double
    let min: Double
}

struct Rain: Codable {
    let lastHour: Double
    
    private enum CodingKeys: String, CodingKey {
        case lastHour = "1h"
    }
}

struct Snow: Codable {
    let lastHour: Double
    
    private enum CodingKeys: String, CodingKey {
        case lastHour = "1h"
    }
}



//struct HourlyRain: Codable {
//    let hourlyRain: Double
//
//    enum CodingKeys: String, CodingKey {
//    case hourlyRain = "1h"
//        }
//}
//
//struct HourlySnow: Codable {
//    let hourlySnow: Double
//
//    enum CodingKeys: String, CodingKey {
//    case hourlySnow = "1h"
//        }
//}


//struct WeatherbitData: Codable {
//    struct DetailInfo: Codable {
//        let minimumTemp: Double
//        let maximumTemp: Double
//        let weatherIcon: String
//        let averageTemp: Double
//        let week: Date
//        let sunrise: Date
//        let sunset: Date
//        let explanation: String
//        let snowingPercent: Int
//        let humidity: Int
//        let wind: Int
//        let rainyPercent: Int
//        let atmosphericPressure: Int
//        let lineOfSight: Int
//        let UVIndex: Int
//    }
//}
//
//enum CodingKeys: String, CodingKey {
//    case lat, lon, timezone
//    case timezoneOffset = "timezone_offset"
//    case current, hourly, daily
//}
