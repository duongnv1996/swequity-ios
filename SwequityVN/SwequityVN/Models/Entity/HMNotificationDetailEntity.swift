//
//  HMNotificationDetailEntity.swift
//  SwequityVN
//
//  Created by RTC-HN360 on 7/27/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit

struct HMNotificationDetailEntity: Decodable {
    let id: String
    let title: String
    let content: String
    let date: String
    let user_read: String
}
