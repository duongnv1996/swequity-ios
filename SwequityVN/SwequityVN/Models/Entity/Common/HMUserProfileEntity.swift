//
//  HMUserProfileEntity.swift
//  ProjectBase
//
//  Created by NamNH-D1 on 4/9/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit

enum LoginType {
    case undentified
    case facebook
    case google
    case phone
    case instagram
    case zalo
    case twitter
}

struct HMUserProfileEntity {
    var uid: String
    var name: String
    var email: String
    var type: LoginType
    
    init() {
        uid = ""
        name = ""
        email = ""
        type = .undentified
    }
}
