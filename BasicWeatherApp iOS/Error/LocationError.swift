//
//  LocationError.swift
//  BasicWeatherApp iOS
//
//  Created by 임현규 on 2020/12/31.
//

import Foundation

enum CreationError: Error {
    case toWeatherViewController
    case toSearchViewController
    
    func andReturn() -> Never {
        fatalError("self")
    }
}
