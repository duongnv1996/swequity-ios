//
//  HMNutritionGoal003Cell.swift
//  SwequityVN
//
//  Created by Tung QT on 7/27/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit

protocol HMNutritionGoal003Delegate: NSObjectProtocol {
    func tapToAddFood3()
}

class HMNutritionGoal003Cell: UITableViewCell {
    
    weak var delegate: HMNutritionGoal003Delegate?

    @IBOutlet weak var leftStackView: UIStackView!
    @IBOutlet weak var rightStackView: UIStackView!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // remove separator
        self.separatorInset = UIEdgeInsets(top: 0, left: 1000, bottom: 0, right: 0)
    }

    var data: AnyObject? {
        didSet {
            if data is HMNutritionGoal003Entity {
                let dto: HMNutritionGoal003Entity = data as! HMNutritionGoal003Entity
                setUpData(dto: dto)
            }
        }
    }
    
    func setUpData(dto: HMNutritionGoal003Entity) {
        titleLabel.text = dto.titleName
        addLabelToStack(foods: dto.foods)
    }
    
    private func addLabelToStack(foods: [String]) {
        for (index, food) in foods.enumerated() {
            if index % 2 == 0 {
                leftStackView.addArrangedSubview(initStackView(value: food))
            } else {
                rightStackView.addArrangedSubview(initStackView(value: food))
            }
            
        }
        leftStackView.addArrangedSubview(UIView())
        rightStackView.addArrangedSubview(UIView())
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
        delegate?.tapToAddFood3()
    }
}
