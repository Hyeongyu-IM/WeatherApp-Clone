//
//  LocationListCellType.swift
//  BasicWeatherApp iOS
//
//  Created by 임현규 on 2021/01/03.
//

import Foundation

enum LocationListCellType: Int {
    static let numberOfSection = 2
    
    case currentLocation = 0
    case savedLocations
    
    init?(rowIndex: Int) {
        self = rowIndex == LocationListCellType.currentLocation.rawValue ? .currentLocation : .savedLocations
    }
    
    var canEditRows: Bool {
        switch self {
        case .currentLocation:
            return false
        case .savedLocations:
            return true
        }
    }
    
    var defaultText: String? {
        switch self {
        case .currentLocation:
            return "Current Location"
        case .savedLocations:
            return nil
        }
    }
}
