//
//  WeatherListCellDelegate.swift
//  BasicWeatherApp iOS
//
//  Created by 임현규 on 2021/01/06.
//

import Foundation

protocol WeatherListCellDelegate: AnyObject {
    func WeatherListCellDelegate(cellData: WeatherListViewCell, index: Int)
}
