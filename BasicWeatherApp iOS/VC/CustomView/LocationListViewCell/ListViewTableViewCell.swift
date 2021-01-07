//
//  ListViewTableViewCell.swift
//  BasicWeatherApp iOS
//
//  Created by 임현규 on 2021/01/03.
//

import UIKit

class ListViewTableViewCell: UITableViewCell {
    static let registerID: String = "\(ListViewTableViewCell.self)"

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var stateNameLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
//    var background: UIColor = .clear
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.backgroundColor = background
//        print("self.backgroundColor \(self.backgroundColor)")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setWeatherData(from weatherItem: WeatherListViewCell) {
        self.timeLabel.text = weatherItem.time
//        self.stateNameLabel.text = String(weatherItem.state.split(separator: "/")[1])
        self.stateNameLabel.text = weatherItem.state
        self.currentTempLabel.text = weatherItem.currentTempC
        self.backgroundColor = getbackgroundImage(weatherItem.time)
        print("background--> \(self.backgroundColor)")
    }
    
    func getbackgroundImage(_ time: String) -> UIColor {
        let time = Int(time.map {String($0)}[3])!
        let colorName: String = ImageBackgroundType(time).rawValue
        let image = UIImage(named: colorName)!
        let color = UIColor(patternImage: image)
        return color
    }
    
}
