//
//  ImageFileManager.swift
//  BasicWeatherApp iOS
//
//  Created by 임현규 on 2020/12/23.
//

import UIKit
import Alamofire

class ImageFileManager {
    let fileManager = FileManager.default
    
    weak var delegate : ImageDownloadCompleteDelegate?
    
    let iconsName: [String] = ["01d", "02d", "03d", "04d", "09d", "10d", "11d", "13d", "50d", "01n", "02n", "03n", "04n", "09n", "10n", "11n", "13n", "50n" ]
    
    func saveImage(_ image: UIImage,_ name: String, completion: @escaping () -> Void) {
        let url = "http://openweathermap.org/img/wn/\(name)@2x.png"
        
        guard let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else { return }
        
        var filePath = URL(fileURLWithPath: path)
        filePath.appendPathComponent((url as NSString).lastPathComponent)
        
        if !fileManager.fileExists(atPath: filePath.path) {
            fileManager.createFile(atPath: filePath.path,
                                   contents: image.pngData(),
                                   attributes: nil)
        completion()
        }
    }
    
    func loadImage(_ name: String) -> UIImage {
        let url = "http://openweathermap.org/img/wn/\(name)@2x.png"
        guard let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else { return UIImage() }
        
        var filePath = URL(fileURLWithPath: path)
        filePath.appendPathComponent((url as NSString).lastPathComponent)
        
        if fileManager.fileExists(atPath: filePath.path) {
            guard let imageData = try? Data(contentsOf: filePath) else {
                return UIImage()
            }
            guard let image = UIImage(data: imageData) else {
                return UIImage()
            }
            return image
        }
        return UIImage()
    }
    
    func checkingImagefile(_ name: String) -> Bool {
        let url = "http://openweathermap.org/img/wn/\(name)@2x.png"
        guard let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else { return false }
        
        var filePath = URL(fileURLWithPath: path)
        
        filePath.appendPathComponent((url as NSString).lastPathComponent)
        return fileManager.fileExists(atPath: filePath.path)
    }
    
    func storageImageChecking(_ weatherInfo: WeatherInfo) {
        guard let image = weatherInfo.daily.first?.weather.first?.icon else{ return }
        if checkingImagefile(image) {
        } else {
            saveAllWeatherIcon(iconsName)
        }
    }
    
    
        func downloadWeatherIcon(_ name: String, completion: @escaping (UIImage?, String, Error?) -> Void) {
            let url = "http://openweathermap.org/img/wn/\(name)@2x.png"
            AF.download(url)
                .downloadProgress { progress in
                    print("Download Progress: \(progress.fractionCompleted)")
                }.response { response in
                    if response.error == nil, let imagePath = response.fileURL?.path {
                        let image = UIImage(contentsOfFile: imagePath)
                        completion(image, name, nil)
                    } else {
                    print(ServiceError.impossibleToGetImageData)
                    completion(nil, name, nil)
                }
            }
        }
    
    func saveAllWeatherIcon(_ iconNameList: [String]) {
        iconNameList.forEach {
            downloadWeatherIcon($0) { (image, name, error) in
                guard let image = image else { return }
                self.saveImage(image, name)  { [self] in
                    delegate?.ImageDownloadCompleteDelegate()
                    }
                }
            }
        }
    }
