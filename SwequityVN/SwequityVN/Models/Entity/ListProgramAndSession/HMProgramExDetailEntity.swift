//
//  HMProgramExListEntity.swift
//  SwequityVN
//
//  Created by RTC-HN360 on 7/27/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit

struct HMProgramExDetailEntity: Decodable {
    let id: String
    let user_id: String
    let title: String
    let date_start: String
    let date_end: String
    let number_day: String
    let active: String
    let session: String
    let listSession: Array<HMSessionExDetailEntity>?
}
