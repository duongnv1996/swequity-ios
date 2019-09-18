//
//  HMDiarySetCell.swift
//  SwequityVN
//
//  Created by RTC-HN360 on 8/11/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit

class HMDiarySetCell: UITableViewCell {

    private let colorRed: UIColor = UIColor(red: 208.0 / 255.0, green: 2.0 / 255.0, blue: 27.0 / 255.0, alpha: 1.0)
    private let colorGray: UIColor = UIColor(red: 151.0 / 255.0, green: 151.0 / 255.0, blue: 151.0 / 255.0, alpha: 1.0)
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var number1Label: UILabel!
    @IBOutlet weak var number2Label: UILabel!
    @IBOutlet weak var number3Label: UILabel!
    
    var type: TypeSetExercise = .normal
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // remove separator
        self.separatorInset = UIEdgeInsets(top: 0, left: 1000, bottom: 0, right: 0)
        number2Label.text = "0"
        number3Label.text = "12"
    }
    
    func setData(data: HMSetsDetailEntity, index: Int, type: TypeSetExercise) {
        number1Label.text = "\(index + 1)"
        number2Label.text = "\(data.weight) kg"
        number3Label.text = data.number
        setUICricle(type: type)
    }
    
    private func setUICricle(type: TypeSetExercise) {
        switch type {
        case .normal:
            circleView.backgroundColor = .white
            number1Label.textColor = .black
            circleView.layer.borderColor = colorGray.cgColor
            circleView.layer.borderWidth = 2.0
        case .highlight:
            circleView.backgroundColor = colorRed
            number1Label.textColor = .white
            circleView.layer.borderColor = colorRed.cgColor
            circleView.layer.borderWidth = 2.0
        }
    }
    
}
