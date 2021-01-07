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
    lazy var weatherListTableCell = WeatherListViewCell(time: "", state: "", currentTempC: "") {
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
            print("self.location.value?.name \(self.location.value?.name)")
        }
        let weatherCellDataMaker = WeatherCellDataMaker(data: weatherInfo)
        self.weatherDescription = "오늘: 현재 날씨 청명함, 기온은 5º이며 오늘 예상 최고 기온은 10º입니다"
        self.hourlyTableViewCell = weatherCellDataMaker.getHourDataCell()
        self.detailTableViewCell = weatherCellDataMaker.getdetailDataCell()
        self.customHeaderViewData = weatherCellDataMaker.getheaderDataCell()
        self.weatherListTableCell = weatherCellDataMaker.getWeatherListDataCell()
        self.weekendTableViewCell.value = weatherCellDataMaker.getWeekendDataCell()
    }
    
    
//    //MARK: - CoreDataLoad and API Call
//
//    func convertCoreData(completion: @escaping () -> Void) {
//        if coreData.count != 0 {
//            coreData.compactMap {
//                WeatherAPI.shared.getWeatherInfo($0.latitude, $0.longitude) { (result) in
//                    self.weatherDataList.insert(result, at: self.weatherDataList.count)
//                    completion()
//                    }
//                }
//            } else {
//                print("코어데이터에 데이터가 없습니다")
//            }
//        }
//}

//    func cellDataUpdate() {
//        self.hourlyTableViewCellBinder.value = self.weatherDataList.map { self.hourDataConfig($0)}
//        self.detailTableViewCellBinder.value = self.weatherDataList.map { self.detailDataConfig($0)}
//        self.customHeaderViewDataBinder.value = self.weatherDataList.map { self.headerDataConfig($0)}
//        self.weekendTableViewCellBinder.value = self.weatherDataList.map { self.weekendDataConfig($0)}
//        self.weatherListTableCellBinder.value = self.weatherDataList.map { self.weatherListDataConfig($0)}
//    }

//MARK: - Refresh Data
//    func refreshData() {
//       let newCoreData = coreDataManager.getLocation()
//        coreData = newCoreData
//        convertCoreData { [weak self] () in
//            self?.hourlyTableViewCellBinder.value = self?.weatherDataList.map { self?.hourDataConfig( $0 ) } as! [[HourCell]]
//            self?.detailTableViewCellBinder.value = self?.weatherDataList.map { self?.detailDataConfig( $0 ) } as! [DetailCell]
//            self?.customHeaderViewDataBinder.value = self?.weatherDataList.map { self?.headerDataConfig($0) } as! [HeaderCell]
//            self?.weekendTableViewCellBinder.value = self?.weatherDataList.map { self?.weekendDataConfig( $0 ) } as! [[WeekendCell]]
//            self?.weatherListTableCellBinder.value = self?.weatherDataList.map { self?.weatherListDataConfig( $0 ) } as! [WeatherListViewCell]
//        }
//    }

//func addLocation(_ latitude: Double,_ longitude: Double) {
//        coreDataManager.saveLocation(latitude: latitude, longitude: longitude)
//        WeatherAPI.shared.getWeatherInfo(latitude, longitude) { (result) in
//            self.hourCells.append(self.hourDataConfig(result))
//            self.detailCells.append(self.detailDataConfig(result))
//            self.weekendCells.append(self.weekendDataConfig(result))
//        }
//    }

//MARK: - Data delete, Add
//    func hourCellDelete(_ index: Int,_ hourCellList: [[HourCell]]) -> [[HourCell]] {
//        var hourCellList = hourCellList
//        hourCellList.remove(at: index)
//        return hourCellList
//    }
//
//    func detailCellDelete(_ index: Int,_ detailCellList: [DetailCell]) -> [DetailCell] {
//        var detailCellList = detailCellList
//        detailCellList.remove(at: index)
//        return detailCellList
//    }
//
//    func weekendCellDelete(_ index: Int,_ weekendCellList: [[WeekendCell]]) -> [[WeekendCell]] {
//        var weekenCellList = weekendCellList
//        weekenCellList.remove(at: index)
//        return weekendCellList
//    }
    }
