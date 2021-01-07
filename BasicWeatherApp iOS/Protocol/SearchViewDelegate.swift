//
//  SearchViewDelegate.swift
//  BasicWeatherApp iOS
//
//  Created by 임현규 on 2020/12/31.
//

import Foundation

protocol SearchViewDelegate: AnyObject {
    func userSelected(newLocation: Location)
}
