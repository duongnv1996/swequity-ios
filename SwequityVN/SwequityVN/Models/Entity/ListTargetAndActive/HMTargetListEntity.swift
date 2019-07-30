//
//  HMTargetListEntity.swift
//  SwequityVN
//
//  Created by RTC-HN360 on 7/27/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit

struct HMTargetListEntity: Decodable {
    let list: Array<HMTargetDetailEntity>
}

struct HMTargetDetailEntity: Decodable {
    let id: String
    let title: String
    let value: String
    let date: String
    let active: String
}
