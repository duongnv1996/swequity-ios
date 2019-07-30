//
//  HMBodyImageEntity.swift
//  SwequityVN
//
//  Created by RTC-HN360 on 7/27/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit

struct HMBodyImageEntity: Decodable {
    let front: Array<HMBodyImageDetailEntity>
    let side: Array<HMBodyImageDetailEntity>
    let back: Array<HMBodyImageDetailEntity>
}

struct HMBodyImageDetailEntity: Decodable {
    let id: String
    let user_id: String
    let img: String
    let type: String
    let date: String
    let active: String
}
