//
//  HMUserInfoRealm.swift
//  Develop
//
//  Created by RTC-HN360 on 7/28/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import RealmSwift

class HMUserInfoRealm: Object {
    @objc dynamic var userId: String?
    @objc dynamic var userName: String?
    @objc dynamic var avatar: String?
    @objc dynamic var phone: String?
    @objc dynamic var email: String?
    @objc private dynamic var privateType: String = "1"
    
    var type: HMAccountType? {
        get { return HMAccountType(rawValue: privateType) }
        set { privateType = newValue?.rawValue ?? "1" }
    }
    
    override static func primaryKey() -> String? {
        return "userId"
    }
}
