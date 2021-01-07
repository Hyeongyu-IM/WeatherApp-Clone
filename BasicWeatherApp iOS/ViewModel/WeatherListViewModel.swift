//
//  WeatherListViewModel.swift
//  BasicWeatherApp iOS
//
//  Created by 임현규 on 2021/01/06.
//

import Foundation

class WeatherListViewModel {
    private let coreDatas = CoreDataManager()
    let weatherAPI = WeatherAPI()
    private var utcTimeConvertor = DateConverter()
    var locationList: Binder<[WeatherListViewCell]>
    var temporaryData: Location {
        willSet {
            convertLocationToCellData(newValue)
        }
    }
    
    init() {
        self.locationList = Binder([])
        temporaryData = Location(name: "", latitude: 0, longitude: 0)
        getCoreDatas()
    }
    
    func getCoreDatas() {
        self.locationList.value = coreDatas.getListViewData()
    }
    
    func convertLocationToCellData(_ location: Location) {
        weatherAPI.getWeatherInfo(location) { [weak self] (data, error)  in
            guard let data = data, error == nil else { return }
            let cellData = WeatherListViewCell(time: self!.utcTimeConvertor.convertDateFromUTC(string: String(data.current.dt), timezone: data.timezone_offset).dtToTimeWithLetter() ,state: location.name!, currentTempC: "\(temperature: Temperature(kelvin: data.current.temp).text)")
            self!.locationList.value?.append(cellData)
        }
    }
}
