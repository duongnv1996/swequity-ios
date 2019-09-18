//
//  HMTargetEntity.swift
//  SwequityVN
//
//  Created by RTC-HN360 on 8/8/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit

struct HMTargetEntity: Decodable {
    let id: String
    let user_id: String
    let id_target_week: String
    let id_level: String
    let khoiluong: String
    let khoiluongmuctieu: String
    let tylemo: String
    let mucdovandong: String
    let protein: String
    let fat: String
    let carb: String
    let other: String
    let total: String
    let date: String
    let time_update: String
    let time_update_target_week: String
    let active: String
}
