//
//  LocationListDelegate.swift
//  BasicWeatherApp iOS
//
//  Created by 임현규 on 2020/12/31.
//

import UIKit

protocol LocationListViewDelegate: AnyObject {
    func userDidSelectLocation(at index: Int,image: UIColor)
    func userAdd(newLocation: Location)
    func userDeleteLocation(at index: Int)
}
