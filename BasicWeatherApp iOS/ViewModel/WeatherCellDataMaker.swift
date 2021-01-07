//
//  weatherCellDataMaker.swift
//  BasicWeatherApp iOS
//
//  Created by 임현규 on 2020/12/31.
//

import UIKit

class WeatherCellDataMaker {
    private let data: WeatherInfo
    private let maxItemCount = 20
    private var utcTimeConvertor = DateConverter()
    private let imageFileManager = ImageFileManager()
    
    init(data: WeatherInfo) {
        self.data = data
    }
    
    //MARK: - HourlyCollectionCell Data Config
    func getHourDataCell() -> [HourCell]{
        let sunsetDT = isSunRiseOrSunSetAlreadyPast("sunset")
        let sunriseDT = isSunRiseOrSunSetAlreadyPast("sunrise")
        let sunsetCell = HourCell(dt: sunsetDT ,
                                  time: utcTimeConvertor.convertDateFromUTC(string: String(sunsetDT), timezone: data.timezone_offset).dtToTimeWithLetter() ,
                                  icon: UIImage(systemName: "sunset.fill")!.withTintColor(.white) ,
                                  Ctemp: "일몰")
        let sunriseCell = HourCell(dt: sunriseDT,
                                   time: utcTimeConvertor.convertDateFromUTC(string: String(sunriseDT), timezone: data.timezone_offset).dtToTimeWithLetter(),
                                   icon: UIImage(systemName: "sunrise.fill")!.withTintColor(.white),
                                   Ctemp: "일출")
        let currentCell = HourCell(dt: data.current.dt,
                                   time: "지금",
                                   icon: imageFileManager.loadImage("\(data.daily[0].weather[0].icon)"),
                                   Ctemp: "\(temperature: Temperature(kelvin: data.current.temp).text)")
        
        var hourCells: [HourCell] = data.hourly.map {
            HourCell(dt: $0.dt ,
                     time: utcTimeConvertor.convertDateFromUTC(string: String(sunsetDT), timezone: data.timezone_offset).dtToTimeWithLetter(),
                     icon: imageFileManager.loadImage("\($0.weather[0].icon)"),
                     Ctemp: "\(temperature: Temperature(kelvin: $0.temp).text)")
        }
        hourCells.append(sunsetCell)
        hourCells.append(sunriseCell)
        hourCells.sort { $0.dt < $1.dt }
        // 현재시간 5:10분 이면 5시가 들어있기때문에 5시를 삭제합니다.
        hourCells.removeFirst()
        // 현재시간 5:10(지금)을 넣고, 다음셀은 6시 부터 표시.
        hourCells.insert(currentCell, at: 0)
        return hourCells
    }
    
    //MARK: - WeekendTableData Config
    func getWeekendDataCell() -> [WeekendCell] {
        let weekendCells = data.daily.map {
            WeekendCell(weekend: utcTimeConvertor.convertDateFromUTC(string: String($0.dt), timezone: data.timezone_offset).dtToWeekend(),
                             icon: imageFileManager.loadImage("\($0.weather[0].icon)"),
                             minCTemp: "\(temperature: Temperature(kelvin: $0.temp.min).text)",
                             maxCTemp: "\(temperature: Temperature(kelvin: $0.temp.max).text)",
                             percent: "")
        }
        return weekendCells
    }
    
    //MARK: - DetailData Config
    func getdetailDataCell() -> DetailCell {
        let detailCell: DetailCell = DetailCell(sunrise: utcTimeConvertor.convertDateFromUTC(string: String(data.current.sunrise), timezone: data.timezone_offset).curretTime(),
                                                sunset: utcTimeConvertor.convertDateFromUTC(string: String(data.current.sunset), timezone: data.timezone_offset).curretTime(),
                                                snow: String(data.current.snow?.lastHour ?? 0),
                                                humidity: "\(humidity: data.current.humidity)",
                                                wind: "\(wind: data.current.wind_speed)",
                                                feelsLike: String(data.current.feels_like),
                                                rain: String(data.current.rain?.lastHour ?? 0),
                                                pressure:"\(pressure: data.current.pressure)",
                                                visibility: String(data.current.visibility),
                                                uvi: String(data.current.uvi))
        return detailCell
    }
    
    //MARK: - HeaderCell DataConfig
    func getheaderDataCell() -> HeaderCell {
        let currentTemp = Temperature(kelvin: data.current.temp).text.first == "-" ? "\(temperature: Temperature(kelvin: data.current.temp).text)" : "  \(temperature: Temperature(kelvin: data.current.temp).text)"
        let headerCell: HeaderCell = HeaderCell(state: (data.timezone.firstIndex(of: "/") != nil) ? String(data.timezone.split(separator: "/")[1]) : data.timezone ,
                                                description: String(data.current.weather.first?.description ?? "" ),
                                                currentTemp: currentTemp,
                                                minTemp: "최저:\(temperature: Temperature(kelvin: data.daily[0].temp.min).text)" ,
                                                maxTemp: "최고:\(temperature: Temperature(kelvin: data.daily[0].temp.max).text)")
        return headerCell
    }
    
    //MARK: - WeatherListTableCell DataConfig
    func getWeatherListDataCell() -> WeatherListViewCell {
        let weatherListCell = WeatherListViewCell(time: utcTimeConvertor.convertDateFromUTC(string: String(data.current.dt), timezone: data.timezone_offset).curretTime(),
                                                  state: (data.timezone.firstIndex(of: "/") != nil) ? String(data.timezone.split(separator: "/")[1]) : data.timezone,
                                                  currentTempC: "\(temperature: Temperature(kelvin: data.current.temp).text)")
        return weatherListCell
    }
    
    private func isSunRiseOrSunSetAlreadyPast(_ dataName: String) -> Int {
        switch dataName {
        case "sunrise":
         if data.current.dt > data.current.sunrise {
                return data.daily[1].sunrise
                } else {
                    return data.current.sunrise ?? 0
                }
        case "sunset":
         if data.current.dt > data.current.sunset {
            return data.daily[1].sunset
            } else {
                return data.current.sunset
            }
        default:
            return 0
            }
        }
    }
