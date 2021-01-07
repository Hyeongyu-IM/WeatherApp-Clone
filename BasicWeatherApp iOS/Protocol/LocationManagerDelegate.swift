//
//  LocationListViewDelegate.swift
//  BasicWeatherApp iOS
//
//  Created by 임현규 on 2020/12/31.
//

import Foundation

protocol LocationManagerDelegate: AnyObject {
    func locationManagerDidUpdate(currentLocation: Location)
}
