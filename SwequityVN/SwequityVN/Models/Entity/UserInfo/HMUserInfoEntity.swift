//
//  HMUserInfoEntity.swift
//  SwequityVN
//
//  Created by RTC-HN360 on 7/27/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit

struct HMUserInfoEntity: Decodable {
    let id: String
    let fbid: String
    let ggid: String
    let name: String
    let username: String
    let password: String
    let email: String
    let phone: String
    let birthday: String
    let avatar: String
    let gender: HMGenderType
    let address: String
    let date: String
    let type: HMAccountType
    let weight: String
    let height: String
    let fat: String
    let protein: String
    let gluco: String
    let active: String
    let week_1: String?
    let week_2: String?
    let week_3: String?
    let week_4: String?
    let image: String?
    let tylemo: String?
    let ex: String?
    let number_noty: Int?
}
