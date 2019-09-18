//
//  HMTrainingProgramDetailCell.swift
//  SwequityVN
//
//  Created by Tung QT on 8/5/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
protocol HMTrainingProgramDetailCellDelegate: NSObject {
    func updateTrainingProgram(name: String, programId: String)
}
class HMTrainingProgramDetailCell: UITableViewCell {

    @IBOutlet weak var trainingProgramTextField: UITextField!
    @IBOutlet weak var numberExerciseLabel: UILabel!
    
    var programId: String?
    
    weak var delegate: HMTrainingProgramDetailCellDelegate?
    
    func setData(dto: HMSessionExDetailEntity?) {
        trainingProgramTextField.text = dto?.name
        numberExerciseLabel.text = "\(dto?.number_ex ?? 0) " + "Bài tập"
    }
    
    @IBAction func addTrainingProgram(_ sender: UITextField) {
        self.delegate?.updateTrainingProgram(name: self.trainingProgramTextField.text ?? "", programId: programId ?? "")
    }
    
}
