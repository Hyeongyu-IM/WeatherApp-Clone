//
//  weatherAPI.swift
//  BasicWeatherApp iOS
//
//  Created by 임현규 on 2020/12/13.
//

import UIKit
import Alamofire

typealias WeatherCompletionHandler = (WeatherInfo?, Error?) -> Void

class WeatherAPI {
    let locationGeocoder = LocationGeocoder()
    let imageFileManager = ImageFileManager()
    
    // 새로운 요청이 들어오면 기존 것을 취소하고 현재의 것을 실행합니다.
    private var request: DataRequest? {
        didSet {
            oldValue?.cancel()
        }
    }
    
    func getWeatherInfo(_ location: Location, completion: @escaping WeatherCompletionHandler) {
        let parameters: [String:String] = [
            "lang": "kr",
            "exclude": "minutely",
            "lon": "\(location.longitude)",
            "lat": "\(location.latitude)",
            "appid": "\(WeatherAPIInfo.apiID)"
        ]
       
        AF.request(WeatherAPIInfo.currentWeatherURL,
                   method: .get,
                   parameters:  parameters,
                   encoding: URLEncoding.default,
                   headers: ["Content-Type":"application/json", "Accept":"application/json"])
            .validate(statusCode: 200..<300)
            .responseJSON { (json) in
                switch json.result {
                case .success(let response):
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                        let jsonResponse = try JSONDecoder().decode(WeatherInfo.self, from: jsonData)
                        self.imageFileManager.storageImageChecking(jsonResponse)
                       completion(jsonResponse, nil)
                    } catch( let error) {
                        print("\(ServiceError.impossibleToParseJSON)")
                        completion(nil, error)
                    }
                case .failure(let error):
                    print("\(ServiceError.impossibleToGetJSONData)")
                    completion(nil, error)
                }
        }
    }
}
