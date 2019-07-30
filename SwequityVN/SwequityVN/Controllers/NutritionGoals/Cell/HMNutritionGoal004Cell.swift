//
//  HMNutritionGoal004Cell.swift
//  SwequityVN
//
//  Created by Tung QT on 7/27/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit

protocol HMNutritionGoal004Delegate: NSObjectProtocol {
    func tapToEdit004()
}

class HMNutritionGoal004Cell: UITableViewCell {

    @IBOutlet weak var titleNameLabel: UILabel!
    @IBOutlet weak var statusActLabel: UILabel!
    
    weak var delegate: HMNutritionGoal004Delegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // remove separator
        self.separatorInset = UIEdgeInsets(top: 0, left: 1000, bottom: 0, right: 0)
    }

    var data: AnyObject? {
        didSet {
            if data is HMNutritionGoal004Entity {
                let dto: HMNutritionGoal004Entity = data as! HMNutritionGoal004Entity
                setUpData(dto: dto)
            }
        }
    }
    
    func setUpData(dto: HMNutritionGoal004Entity) {
        titleNameLabel.text = dto.titleName
        statusActLabel.text = dto.statusTort
    }
    
    @IBAction func tapToEdit004(_ sender: Any) {
        delegate?.tapToEdit004()
    }
}
