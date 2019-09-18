//
//  HMEnumType.swift
//  SwequityVN
//
//  Created by RTC-HN360 on 7/27/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit

enum HMGenderType: String, Decodable {
    case undentifier = "0"
    case male = "1"
    case female = "2"
}

enum HMImageType: String, Decodable {
    case front = "1"
    case side = "2"
    case back = "3"
}

enum HMFavouriteType: Int, Decodable {
    case favorite = 1
    case unfavorite = 2
}

enum HMBodyDataType: String, Decodable {
    case khoiluong = "khoiluong"
    case nguc = "nguc"
    case vai = "vai"
    case mong = "mong"
    case eo = "eo"
}

enum HMNutritonType: String, Decodable {
    case fat = "1"
    case protein = "2"
    case gluco = "3"
    case other = "4"
}

enum HMFoodType: String, Decodable {
    case protein = "1"
    case fat = "2"
    case cab = "3"
    case other = "4"
}

enum HMTargetType: String, Decodable {
    case week = "week"
    case action = "action"
}

enum HMTargetFillType: Int {
    case weight = 1
    case fatPer = 2
}

enum HMAccountType: String, Decodable {
    case normal = "1"
    case vip = "2"
}

enum HMListType: Int {
    case list = 1
    case choose = 2
}

enum HMCalendarType: Int {
    case add = 1
    case update = 2
}
