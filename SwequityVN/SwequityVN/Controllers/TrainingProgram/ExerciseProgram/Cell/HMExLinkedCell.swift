//
//  HMExLinkedCell.swift
//  SwequityVN
//
//  Created by NamNH-D1 on 8/20/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit

protocol HMExLinkedCellDelegate: class {
    func invokeLinkedButton(at: HMExLinkedCell, ischecked: Bool)
}

class HMExLinkedCell: UITableViewCell {

    @IBOutlet weak var checkedButton: HMCheckBoxButton!
    weak var delegate: HMExLinkedCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setContentWithEntity(isDisplayLinkedButton: Bool) {
        self.checkedButton.isChecked = isDisplayLinkedButton
    }
    
    @IBAction func invokeLinkedButton(_ sender: HMCheckBoxButton) {
        delegate?.invokeLinkedButton(at: self, ischecked: !sender.isChecked)
    }
}
