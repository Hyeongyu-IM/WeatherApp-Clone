//
//  ImageLoad.swift
//  BasicWeatherApp iOS
//
//  Created by 임현규 on 2021/01/12.
//

import UIKit

extension UIImageView {
    func loadFromDirectory(imageName name: String){
        if let systemImage = UIImage(systemName: name) {
            systemImage.withTintColor(.white)
            DispatchQueue.main.async {
            self.image = systemImage
            }
            return
        }
        let url = "http://openweathermap.org/img/wn/\(name)@2x.png"
        guard let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else { return }
        var filePath = URL(fileURLWithPath: path)
        filePath.appendPathComponent((url as NSString).lastPathComponent)
        
        if FileManager.default.fileExists(atPath: filePath.path) {
            guard let imageData = try? Data(contentsOf: filePath) else { return }
            guard let image = UIImage(data: imageData) else { return }
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
}
