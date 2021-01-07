//
//  ImageBackgroundType.swift
//  BasicWeatherApp iOS
//
//  Created by 임현규 on 2021/01/06.
//

import Foundation

enum ImageBackgroundType: String {
    case sunny = "sunny"
    case night = "night"
    case sunset = "sunset"
    case rainy = "rainy"
    
    init(_ time: Int) {
        switch time {
        case 0...7:
            self = .night
        case 8...15:
            self = .sunny
        case 16...18:
            self = .sunset
        case 19...24:
            self = .night
        default:
            self = .rainy
        }
    }
}
