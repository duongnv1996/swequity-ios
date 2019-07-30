//
//  HMExerciseCateCell.swift
//  SwequityVN
//
//  Created by Tung QT on 7/29/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit

class HMExerciseCateCell: UITableViewCell {

    @IBOutlet weak var exeImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // remove separator
        self.separatorInset = UIEdgeInsets(top: 0, left: 1000, bottom: 0, right: 0)
    }
    
    var data: HMExerciseCateEntity? {
        didSet {
            if let data = data {
                setUpData(dto: data)
            }
            
        }
    }
    
    func setUpData(dto: HMExerciseCateEntity) {
        exeImageView.image = dto.image
        titleLabel.text = dto.title
        detailLabel.text = dto.detail
    }
}
