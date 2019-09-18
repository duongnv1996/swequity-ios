//
//  HMExerciseCataCell.swift
//  SwequityVN
//
//  Created by Tung QT on 7/30/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit

class HMExerciseCataCell: UITableViewCell {

    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var numberLabel: UILabel!
    @IBOutlet weak private var contentImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // remove separator
        self.separatorInset = UIEdgeInsets(top: 0, left: 1000, bottom: 0, right: 0)
    }
    
    var data: HMExerciseCataEntity? {
        didSet {
            if let data = data {
                setUpData(dto: data)
            }
        }
    }
    
    func setUpData(dto: HMExerciseCataEntity) {
        contentImageView.image = dto.image
        titleLabel.text = dto.title
        numberLabel.text = dto.numberExercise + " bài"
    }
}
