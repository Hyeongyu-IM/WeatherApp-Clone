//
//  weatherViewModel.swift
//  BasicWeatherApp iOS
//
//  Created by 임현규 on 2020/12/07.
//

import UIKit

 class WeatherViewModel {
    let coreData = CoreDataManager()
    let locationGeocoder = LocationGeocoder()
    let weatherAPI = WeatherAPI()
    let maxItemCount = 20
    let emptyString = ""
    var location: Binder<Location>
    let temperatureUnit: Binder<TemperatureUnit.Unit>
    var hourlyTableViewCell : [HourCell]
    var detailTableViewCell : DetailCell?
    var customHeaderViewData : HeaderCell?
    var weekendTableViewCell : Binder<[WeekendCell]>
    var weatherDescription: String?
    var isHeaderViewMade: Bool
    lazy var weatherListTableCell = WeatherListViewCell(time: "", state: "", currentTempC: "", backgrounTime: "") {
        willSet{
            coreData.saveOrUpdateListViewData(newValue)
        }
    }
    
    init(location: Location) {
        self.location = Binder(location)
        self.hourlyTableViewCell = []
        self.detailTableViewCell = nil
        self.weekendTableViewCell = Binder([])
        self.customHeaderViewData = nil
        self.weatherDescription = nil
        self.temperatureUnit = Binder(TemperatureUnit.shared.unit)
        self.isHeaderViewMade = false
    }
    
    func retrieveWeatherInfo() {
        guard let location = location.value else { return }
        weatherAPI.getWeatherInfo(location) { (weatherInfo, error) in
            guard let weatherInfo = weatherInfo, error == nil else {
                print(error ?? "")
                return
            }
            DispatchQueue.main.async {
                self.update(weatherInfo)
            }
        }
    }
    
    func update(_ weatherInfo: WeatherInfo) {
        if self.location.value?.name == "" {
            self.location.value?.name = weatherInfo.timezone
        }
        let weatherCellDataMaker = WeatherCellDataMaker(data: weatherInfo)
        self.weatherDescription = "오늘: 현재 날씨 청명함, 기온은 5º이며 오늘 예상 최고 기온은 10º입니다"
        self.hourlyTableViewCell = weatherCellDataMaker.getHourDataCell()
        self.detailTableViewCell = weatherCellDataMaker.getdetailDataCell()
        self.customHeaderViewData = weatherCellDataMaker.getheaderDataCell()
        self.weatherListTableCell = weatherCellDataMaker.getWeatherListDataCell()
        self.weekendTableViewCell.value = weatherCellDataMaker.getWeekendDataCell()
    }
 }
