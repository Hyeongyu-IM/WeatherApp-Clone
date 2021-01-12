//
//  WeekendTableViewCell.swift
//  BasicWeatherApp iOS
//
//  Created by 임현규 on 2020/12/28.
//

import UIKit

class WeekendTableViewCell: UITableViewCell {
    
    static let registerID: String = "\(WeekendTableViewCell.self)"

    @IBOutlet weak var weekendLabel: UILabel!
    @IBOutlet weak var weekendIcon: UIImageView!
    @IBOutlet weak var weekendPercent: UILabel!
    @IBOutlet weak var weekendMaxTempLabel: UILabel!
    @IBOutlet weak var weekendMinTempLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
    }
    
    func setWeekendData(weekendData: WeekendCell) {
        self.weekendLabel.text = weekendData.weekend
        self.weekendIcon.loadFromDirectory(imageName: weekendData.icon!)
        self.weekendPercent.text = weekendData.percent ?? ""
        self.weekendMaxTempLabel.text = weekendData.maxCTemp
        self.weekendMinTempLabel.text = weekendData.minCTemp
    }
}
