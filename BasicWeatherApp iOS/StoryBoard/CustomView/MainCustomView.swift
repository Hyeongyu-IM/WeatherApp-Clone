//
//  mainCustomView.swift
//  BasicWeatherApp iOS
//
//  Created by 임현규 on 2020/12/16.
//

import UIKit

class MainCustomView: UIView {
    
    @IBOutlet var mainCustomView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("MainCustomView", owner: self, options: nil)
        addSubview(mainCustomView)
        mainCustomView.frame = self.bounds
        mainCustomView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
