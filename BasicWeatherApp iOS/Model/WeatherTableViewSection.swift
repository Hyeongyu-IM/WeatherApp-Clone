//
//  WeatherTableViewSection.swift
//  BasicWeatherApp iOS
//
//  Created by 임현규 on 2021/01/03.
//

import UIKit

enum WeatherTableViewSection: Int {
    static let numberOfSection = 5
    
    case hour = 0
    case weekend = 1
    case description = 2
    case detail = 3
    case link = 4
    
    init?(sectionIndex: Int) {
        guard let section = WeatherTableViewSection(rawValue: sectionIndex) else {
            return nil
        }
        self = section
    }
    
    var cellHeight: CGFloat {
        switch self {
        case .hour:
            return CGFloat(133)
        case .weekend:
            return CGFloat(44)
        case .description:
            return CGFloat(43.5)
        case .link:
            return CGFloat(43.5)
        case .detail:
            return CGFloat(330)
        }
    }
}
