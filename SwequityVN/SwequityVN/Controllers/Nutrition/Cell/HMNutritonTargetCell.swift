//
//  HMNutritonWeekTargetCell.swift
//  SwequityVN
//
//  Created by RTC-HN360 on 7/30/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
protocol HMNutritonTargetCellDelegate: NSObject {
    func didTapChooseButton()
}

class HMNutritonTargetCell: UITableViewCell {

    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var chooseImageView: UIImageView!
    
    
    weak var delegate:HMNutritonTargetCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func didTapChooseButton(_ sender: UIButton) {
        self.delegate?.didTapChooseButton()
    }
    
    //MARK - Private methods
    func setContentWithEntity(target: HMTargetDetailEntity, isSelect: Bool) {
        if (isSelect) {
            self.chooseImageView.image = UIImage(named: "icon_check_mark")
        } else {
            self.chooseImageView.image = nil
        }
        self.contentLabel.text = target.title
    }
}
