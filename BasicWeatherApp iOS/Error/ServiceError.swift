//
//  ServiceError.swift
//  BasicWeatherApp iOS
//
//  Created by 임현규 on 2020/12/31.
//

import Foundation

enum ServiceError: Error {
    case urlError
    case networkRequestError
    case impossibleToGetJSONData
    case impossibleToParseJSON
    case impossibleToGetImageData
}
