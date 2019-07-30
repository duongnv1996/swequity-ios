//
//  HMSharedData.swift
//  ProjectBase
//
//  Created by NamNH-D1 on 3/13/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit

class HMSharedData {
    // APNS token is saved in app
    class var deviceToken: String? {
        get {
            return (UserDefaults.standard.value(forKey: "NotificationToken") as? String)
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: "NotificationToken")
        }
    }
    
    // Need display splash
    class var needDisplaySplash: Bool {
        get {
            return (UserDefaults.standard.value(forKey: "NeedDisplaySplash") as? Bool ?? false)
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: "NeedDisplaySplash")
        }
    }
    
    // Driver active
    class var active: String? {
        get {
            return (UserDefaults.standard.value(forKey: "Active") as? String)
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: "Active")
        }
    }
    
    // VerifyCode
    class var verifyCode: Int? {
        get {
            return (UserDefaults.standard.value(forKey: "VerifyCode") as? Int)
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: "VerifyCode")
        }
    }
    
    // Service ID
    class var serviceId: String? {
        get {
            return (UserDefaults.standard.value(forKey: "ServiceId") as? String)
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: "ServiceId")
        }
    }
    
    // User ID
    class var userId: String? {
        get {
            return (UserDefaults.standard.value(forKey: "UserId") as? String)
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: "UserId")
        }
    }
}
