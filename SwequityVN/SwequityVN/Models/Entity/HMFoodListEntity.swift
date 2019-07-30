//
//  HMFoodListEntity.swift
//  SwequityVN
//
//  Created by RTC-HN360 on 7/27/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit

struct HMFoodListEntity: Decodable {
    let list: Array<HMFoodDetailEntity>
}

struct HMFoodDetailEntity: Decodable {
    let id: String
    let img: String
    let name: String
    let protein: String
    let fat: String
    let cabs: String
    let calo: String
    let content: String
    let date: String
    let glycemic: String
    let protein_type: String
    let fat_type: String
    let type: String
    let type_detail: String
    let active: String
    let is_favourite: String
    let favorite: Bool?
}
