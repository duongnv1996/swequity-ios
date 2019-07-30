//
//  HMActionLevelEntity.swift
//  SwequityVN
//
//  Created by RTC-HN360 on 7/27/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit

struct HMActionLevelListEntity: Decodable {
    let list: Array<HMActionLevelDetailEntity>
}

struct HMActionLevelDetailEntity: Decodable {
    let id: String
    let title: String
    let value: String
    let date: String
    let active: String
}
