//
//  HMSessionExListEntity.swift
//  SwequityVN
//
//  Created by RTC-HN360 on 7/27/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit

struct HMSessionExDetailEntity: Decodable {
    let id: String
    let program_user_set_id: String
    let user_id: String
    let name: String
    let date: String
    let date_ex: String
    let date_app: String
    let active: String
    let number_ex: Int?
    
    init() {
        id = "0"
        program_user_set_id = ""
        user_id = ""
        name = ""
        date = ""
        date_ex = ""
        date_app = ""
        active = ""
        number_ex = 0
    }
}
