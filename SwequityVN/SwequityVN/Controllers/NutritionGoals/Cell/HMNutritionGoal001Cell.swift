//
//  HMNutritionGoal001Cell.swift
//  SwequityVN
//
//  Created by Tung QT on 7/27/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit

protocol HMNutritionGoal001Delegate: NSObjectProtocol {
    func tapToEdit()
}

class HMNutritionGoal001Cell: UITableViewCell {

    @IBOutlet weak var shadowView: HMShadowView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitle001Label: UILabel!
    @IBOutlet weak var subTitle002Label: UILabel!
    @IBOutlet weak var subTitle003Label: UILabel!
    @IBOutlet weak var value001Label: UILabel!
    @IBOutlet weak var value002Label: UILabel!
    @IBOutlet weak var value003Label: UILabel!
    @IBOutlet weak var date001Label: UILabel!
    @IBOutlet weak var date002Label: UILabel!
    
    weak var delegate: HMNutritionGoal001Delegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // remove separator
        self.separatorInset = UIEdgeInsets(top: 0, left: 1000, bottom: 0, right: 0)
    }
    
    @IBAction func tapToEdit(_ sender: Any) {
        delegate?.tapToEdit()
    }
    
    var data: AnyObject? {
        didSet {
            if data is HMNutritionGoal001Entity {
                let dto: HMNutritionGoal001Entity = data as! HMNutritionGoal001Entity
                setUpData(dto: dto)
            }
        }
    }
    
    func setUpData(dto: HMNutritionGoal001Entity) {
        titleLabel.text = dto.titleName
        subTitle001Label.text = dto.subTitle001
        subTitle002Label.text = dto.subTitle002
        subTitle003Label.text = dto.subTitle003
        value001Label.attributedText = getAttriBute(value: dto.weightCurrent)
        value002Label.attributedText = getAttriBute(value: dto.weightTarget)
        value003Label.text = dto.fatPercent + "%"
        date001Label.text = dto.currentDate
        date002Label.text = dto.targetDate
    }
    
    
    private func getAttriBute(value: String) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: "\(value)kg", attributes: [
            .font: UIFont(name: "OpenSans-Semibold", size: 28.0)!,
            .foregroundColor: UIColor(red: 139.0 / 255.0, green: 87.0 / 255.0, blue: 42.0 / 255.0, alpha: 1.0)
            ])
        attributedString.addAttribute(.font, value: UIFont(name: "OpenSans-Semibold", size: 13.0)!, range: NSRange(location: value.count, length: 2))
        return attributedString
    }
}
