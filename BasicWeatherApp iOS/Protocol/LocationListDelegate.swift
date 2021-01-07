//
//  LocationListDelegate.swift
//  BasicWeatherApp iOS
//
//  Created by 임현규 on 2020/12/31.
//

import Foundation

protocol LocationListViewDelegate: AnyObject {
    func userDidSelectLocation(at index: Int)
    func userAdd(newLocation: Location)
    func userDeleteLocation(at index: Int)
}
