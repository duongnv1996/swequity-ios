//
//  HMExProgramCell.swift
//  SwequityVN
//
//  Created by NamNH-D1 on 8/20/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import Kingfisher

class HMExProgramCell: UITableViewCell {

    @IBOutlet weak var exerciseImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var roundNumberLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var breakTimeLabel: UILabel!
    @IBOutlet weak var linkedView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setContentWithEntity(entity: HMExerciseInSessionDetailEntity, isDisplayLinkedView: Bool) {
        if let imageURL = URL(string: entity.img) {
            exerciseImageView.kf.setImage(with: imageURL)
        }
        nameLabel.text = entity.name
        roundNumberLabel.text = "Số hiệp: \(entity.sets)"
        numberLabel.text = "Số lần tập: \(entity.reps)"
        breakTimeLabel.text = "\(entity.break_time)s"
        linkedView.isHidden = !isDisplayLinkedView
    }

}
