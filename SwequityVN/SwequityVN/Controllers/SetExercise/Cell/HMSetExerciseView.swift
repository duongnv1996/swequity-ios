//
//  HMSetExerciseView.swift
//  SwequityVN
//
//  Created by Tung QT on 8/8/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit


class HMSetExerciseView: UIView {
    
    private let colorRed: UIColor = UIColor(red: 208.0 / 255.0, green: 2.0 / 255.0, blue: 27.0 / 255.0, alpha: 1.0)
    private let colorGray: UIColor = UIColor(red: 151.0 / 255.0, green: 151.0 / 255.0, blue: 151.0 / 255.0, alpha: 1.0)

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var number1Label: UILabel!
    @IBOutlet weak var number2Label: UILabel!
    @IBOutlet weak var number3Label: UILabel!
    @IBOutlet weak var number4Label: UILabel!
    
//    var type: TypeSetExercise = .normal
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        
        isUserInteractionEnabled = false
    }
    
//    func setData(data: String, index: Int, type: TypeSetExercise) {
//        number1Label.text = "\(index + 1)"
//        number2Label.text = "0"
//        number3Label.text = "12"
//        number4Label.text = "25"
//        setUICricle(type: type)
//    }
//    
//    private func setUICricle(type: TypeSetExercise) {
//        switch type {
//        case .normal:
//            circleView.backgroundColor = .white
//            number1Label.textColor = .black
//            circleView.layer.borderColor = colorGray.cgColor
//            circleView.layer.borderWidth = 2.0
//        case .highlight:
//            circleView.backgroundColor = colorRed
//            number1Label.textColor = .white
//            circleView.layer.borderColor = colorRed.cgColor
//            circleView.layer.borderWidth = 2.0
//        }
//    }
    
}
