//
//  CustomHeaderView.swift
//  BasicWeatherApp iOS
//
//  Created by 임현규 on 2020/12/27.
//

import UIKit

class CustomHeaderView: UIView {

    @IBOutlet weak var cityNameCenterY: NSLayoutConstraint!
    @IBOutlet weak var tempStackView: UIStackView!
    
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    
    static func instance() -> CustomHeaderView {
        return Bundle(for: CustomHeaderView.self).loadNibNamed(String(describing: CustomHeaderView.self), owner: nil, options: nil)![0] as! CustomHeaderView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
    }
    
    func setHeaderData(_ headerData: HeaderCell) {
        self.stateLabel.text = String(headerData.state)
        self.descriptionLabel.text = headerData.description
        self.currentTempLabel.text = headerData.currentTemp
        self.minTempLabel.text = headerData.minTemp
        self.maxTempLabel.text = headerData.maxTemp
    }
    
    
}

