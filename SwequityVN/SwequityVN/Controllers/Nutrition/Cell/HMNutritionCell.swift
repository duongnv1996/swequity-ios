//
//  HMNutritionCell.swift
//  SwequityVN
//
//  Created by Nguyễn Nam on 7/26/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit

protocol HMNutritionCellDelegate: NSObject {
    func didTapFavoriteButton(idFood: String, isFavourited: Bool)
    func didChangeValue(foodId: String, value: String)
}

class HMNutritionCell: UITableViewCell {

    
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var contentNutritionView: UIView!
    @IBOutlet weak var favoriteButton: UIButton!
    
    weak var delegate:HMNutritionCellDelegate?
    
    private var isFavourited:Bool = false
    private var food:HMFoodDetailEntity?
    
    
    func setContentWithEntity(food: HMFoodDetailEntity, withType type:HMFavouriteType) {
        if (food.is_favourite == 1 || type == .favorite) {
            self.isFavourited = true
            self.favoriteButton.setImage(UIImage(named: "icon_like"), for: .normal)
            self.favoriteButton.setImage(UIImage(named: "icon_like"), for: .highlighted)
        } else {
            self.isFavourited = false
            self.favoriteButton.setImage(UIImage(named: "icon_unfavourite"), for: .normal)
            self.favoriteButton.setImage(UIImage(named: "icon_unfavourite"), for: .highlighted)
        }
        self.nameLabel.text = food.name
        self.food = food
        
        var contentColor:UIColor = UIColor()
        if let foodTypeString = self.food?.type {
            let foodType:HMFoodType = HMFoodType(rawValue: foodTypeString)!
            switch foodType {
            case HMFoodType.protein:
                contentColor = .nutritionYellow
                break
            case HMFoodType.fat:
                contentColor = .nutritionOrange
                break
            case HMFoodType.cab:
                contentColor = .nutritionRed
                break
            case HMFoodType.other:
                contentColor = .appleGreen
                break
            }
        }
        self.contentNutritionView.backgroundColor = contentColor
        self.favoriteButton.isEnabled = type == .unfavorite
    }
    
    @IBAction func didTapFavoriteButton(_ sender: UIButton) {
        self.isFavourited = !self.isFavourited
        self.delegate?.didTapFavoriteButton(idFood: self.food!.id, isFavourited: self.isFavourited)
    }
    
    @IBAction func changedValueNutrition(_ sender: HMSlider) {
        self.valueLabel.text = "\(sender.value)g"
        if let foodId = food?.id {
            delegate?.didChangeValue(foodId: foodId, value: "\(sender.value)")
        }
    }
}
