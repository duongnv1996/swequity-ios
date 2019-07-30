//
//  HMEnumType.swift
//  SwequityVN
//
//  Created by RTC-HN360 on 7/27/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit

enum HMGender: String, Decodable {
    case male = "1"
    case female = "2"
}

enum HMImageType: String, Decodable {
    case front = "1"
    case side = "2"
    case backSide = "3"
}

enum HMFavouriteType: String, Decodable {
    case favorite = "1"
    case unfavorite = "2"
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
}
