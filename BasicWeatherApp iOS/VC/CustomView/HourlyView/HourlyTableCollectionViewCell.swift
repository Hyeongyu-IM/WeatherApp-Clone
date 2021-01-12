//
//  WeekendTableCollectionViewCell.swift
//  BasicWeatherApp iOS
//
//  Created by 임현규 on 2020/12/28.
//

import UIKit

class HourlyTableCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var weekendLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var hourlyTemp: UILabel!
    
    static let registerID: String = "\(HourlyTableCollectionViewCell.self)"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
    }
    
    func setHourData(_ hourData: HourCell) {
        self.weekendLabel.text = hourData.time
        self.hourlyTemp.text = hourData.Ctemp
        self.weatherIcon.loadFromDirectory(imageName: hourData.icon)
    }
}
