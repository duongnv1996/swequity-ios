//
//  HMNutritionGoal005Cell.swift
//  SwequityVN
//
//  Created by Tung QT on 7/27/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit

protocol HMNutritionGoal005Delegate: NSObjectProtocol {
    func tapToEdit005()
}

class HMNutritionGoal005Cell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var caloLabel: UILabel!
    @IBOutlet weak var kindFood001Label: UILabel!
    @IBOutlet weak var kindFood002Label: UILabel!
    @IBOutlet weak var kindFood003Label: UILabel!
    @IBOutlet weak var kindFood004Label: UILabel!
    @IBOutlet weak var valueFood001Label: UILabel!
    @IBOutlet weak var valueFood002Label: UILabel!
    @IBOutlet weak var valueFood003Label: UILabel!
    @IBOutlet weak var valueFood004Label: UILabel!
    
    weak var delegate: HMNutritionGoal005Delegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // remove separator
        self.separatorInset = UIEdgeInsets(top: 0, left: 1000, bottom: 0, right: 0)
    }

    var data: AnyObject? {
        didSet {
            if data is HMNutritionGoal005Entity {
                let dto: HMNutritionGoal005Entity = data as! HMNutritionGoal005Entity
                setUpData(dto: dto)
            }
        }
    }
    
    func setUpData(dto: HMNutritionGoal005Entity) {
        titleLabel.text = dto.titleName
        caloLabel.text = dto.caloValue + " Cal"
        if dto.elementFoods.count == 4 {
            kindFood001Label.text = dto.elementFoods[0].titleName
            kindFood002Label.text = dto.elementFoods[1].titleName
            kindFood003Label.text = dto.elementFoods[2].titleName
            kindFood004Label.text = dto.elementFoods[3].titleName
            valueFood001Label.text = getValue(element: dto.elementFoods[0])
            valueFood002Label.text = getValue(element: dto.elementFoods[1])
            valueFood003Label.text = getValue(element: dto.elementFoods[2])
            valueFood004Label.text = getValue(element: dto.elementFoods[3])
        }
    }
    
    private func getValue(element: ElementFood) -> String {
        return element.percent + "% - " + element.calo + " Cal"
    }
    
    @IBAction func tapToEdit(_ sender: Any) {
        delegate?.tapToEdit005()
    }
}
