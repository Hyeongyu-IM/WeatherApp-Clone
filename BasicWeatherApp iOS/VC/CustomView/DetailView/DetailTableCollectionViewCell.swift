//
//  DetailTableCollectionViewCell.swift
//  BasicWeatherApp iOS
//
//  Created by 임현규 on 2020/12/28.
//

import UIKit

class DetailTableCollectionViewCell: UICollectionViewCell {
    
    static let registerID: String = "\(DetailTableCollectionViewCell.self)"
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.nameLabel.textColor = .white
        self.valueLabel.textColor = .white
        self.backgroundColor = .clear
    }
    
    func setDetailData(_ name: String,_ value: String) {
        self.nameLabel.text = name
        self.valueLabel.text = value
    }
}

