//
//  HMSetExerciseCell.swift
//  SwequityVN
//
//  Created by RTC-HN360 on 8/11/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit

enum TypeSetExercise {
    case normal
    case highlight
}

protocol HMSetExerciseCellDelegate:NSObject {
    func didTapDeleteEx(at cell: HMSetExerciseCell)
    func changeValueEx(weight: String, reps: String, rm:String, at cell: HMSetExerciseCell)
}

class HMSetExerciseCell: UITableViewCell {

    private let colorRed: UIColor = UIColor(red: 208.0 / 255.0, green: 2.0 / 255.0, blue: 27.0 / 255.0, alpha: 1.0)
    private let colorGray: UIColor = UIColor(red: 151.0 / 255.0, green: 151.0 / 255.0, blue: 151.0 / 255.0, alpha: 1.0)
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var number1Label: UILabel!
    @IBOutlet weak var number2Label: UITextField!
    @IBOutlet weak var number3Label: UITextField!
    @IBOutlet weak var number4Label: UILabel!
    
    weak var delegate:HMSetExerciseCellDelegate?
    
    var type: TypeSetExercise = .normal
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setContentWithEntity(entity: HMSetsDetailEntity, with index:Int) {
        number1Label.text = String(index + 1)
        number2Label.text = entity.weight
        number3Label.text = entity.number
        let weight = Int(self.number2Label.text ?? "0") ?? 0
        let reps = Int(self.number3Label.text ?? "0") ?? 0
        self.number4Label.text = String(weight * (1 + reps/30))
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
    
    @IBAction func didTapDeleteEx(_ sender: UIButton) {
        self.delegate?.didTapDeleteEx(at: self)
    }
    
    @IBAction func changeWeightValue(_ sender: UITextField) {
        let weight = Int(self.number2Label.text ?? "0") ?? 0
        let reps = Int(self.number3Label.text ?? "0") ?? 0
        self.number4Label.text = String(weight * (1 + reps/30))
        self.delegate?.changeValueEx(weight: String(weight), reps: String(reps), rm: String(self.number4Label.text ?? "0"), at: self)
    }
    
    @IBAction func changeNumberValue(_ sender: UITextField) {
        let weight = Int(self.number2Label.text ?? "0") ?? 0
        let reps = Int(self.number3Label.text ?? "0") ?? 0
        self.number4Label.text = String(weight * (1 + reps/30))
        self.delegate?.changeValueEx(weight: String(weight), reps: String(reps), rm: String(self.number4Label.text ?? "0"), at: self)
    }
    
    
    
}
