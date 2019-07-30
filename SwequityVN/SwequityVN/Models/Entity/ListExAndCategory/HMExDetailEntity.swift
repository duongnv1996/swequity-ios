//
//  HMExListEntity.swift
//  SwequityVN
//
//  Created by RTC-HN360 on 7/27/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit

struct HMExDetailEntity: Decodable {
    let id: String
    let cat_id: String
    let name: String
    let link_support_1: String
    let link_support_2: String
    let link_instruction: String
    let content: String
    let img: String
    let date: String
    let active: String
    let is_fav: String
    let favorite: Bool?
}
