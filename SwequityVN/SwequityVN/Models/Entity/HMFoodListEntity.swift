//
//  HMFoodListEntity.swift
//  SwequityVN
//
//  Created by RTC-HN360 on 8/7/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit

struct HMFoodListEntity: Decodable {
    let food: [HMFoodDetailEntity]?
    let food_favourite: [HMFoodDetailEntity]?
    let target: HMTargetEntity?
    let target_week: [HMTargetDetailEntity]?
    let level_action: [HMTargetDetailEntity]?
}
