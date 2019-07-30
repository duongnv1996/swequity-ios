//
//  HMNutritionGoal002Cell.swift
//  SwequityVN
//
//  Created by Tung QT on 7/27/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit

protocol HMNutritionGoal002Delegate: NSObjectProtocol {
    func tapToAddFood2()
}

class HMNutritionGoal002Cell: UITableViewCell {
    
    
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var foodsStackView: UIStackView!
    @IBOutlet weak var caloLabel: UILabel!
    weak var delegate: HMNutritionGoal002Delegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // remove separator
        self.separatorInset = UIEdgeInsets(top: 0, left: 1000, bottom: 0, right: 0)
    }

    var data: AnyObject? {
        didSet {
            if data is HMNutritionGoal002Entity {
                let dto: HMNutritionGoal002Entity = data as! HMNutritionGoal002Entity
                setUpData(dto: dto)
            }
        }
    }
    
    private func setUpData(dto: HMNutritionGoal002Entity) {
        titleLabel.text = dto.titleName
        subTitleLabel.text = dto.subTitleName
        caloLabel.text = dto.caloValue + " Cal"
        addLabelToStack(foods: dto.foods)
        
    }
    
    private func addLabelToStack(foods: [String]) {
        for food in foods {
            foodsStackView.addArrangedSubview(initStackView(value: food))
        }
        foodsStackView.addArrangedSubview(UIView())
    }
    
    private func initStackView(value: String) -> UIStackView {
        //Image View
        let imageView = UIImageView()
        imageView.heightAnchor.constraint(equalToConstant: 16.0).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 16.0).isActive = true
        imageView.image = UIImage(named: "icon_spice")
        
        //Text Label
        let textLabel = UILabel()
        textLabel.heightAnchor.constraint(equalToConstant: 19.0).isActive = true
        textLabel.text  = value
        textLabel.font = UIFont(name: "OpenSans", size: 14.0)
        textLabel.textColor = UIColor(red: 85.0 / 255.0, green: 85.0 / 255.0, blue: 85.0 / 255.0, alpha: 1.0)
        textLabel.textAlignment = .left
        
        //Stack View
        let stackView = UIStackView()
        stackView.axis  = NSLayoutConstraint.Axis.horizontal
        stackView.distribution  = UIStackView.Distribution.fill
        stackView.alignment = UIStackView.Alignment.center
        stackView.spacing = 3
        stackView.heightAnchor.constraint(equalToConstant: 19)
        
        //Text Label
        let textLabel1 = UILabel()
        textLabel1.textColor = UIColor.white
        textLabel1.heightAnchor.constraint(equalToConstant: 19.0).isActive = true
        textLabel1.widthAnchor.constraint(equalToConstant: 34.0).isActive = true
        textLabel1.textAlignment = .left
        
        stackView.addArrangedSubview(textLabel1)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(textLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }
    
    @IBAction func tapToAddFood(_ sender: Any) {
        delegate?.tapToAddFood2()
    }
}
