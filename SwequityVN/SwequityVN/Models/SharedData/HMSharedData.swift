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
    
    // Time start
    class var timeStartEx: Date? {
        get {
            return (UserDefaults.standard.value(forKey: "TimeStartEx") as? Date)
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: "TimeStartEx")
        }
    }
    
    // Time start with ex
    class var timeStartWithEx: Date? {
        get {
            return (UserDefaults.standard.value(forKey: "TimeStartWithEx") as? Date)
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: "TimeStartWithEx")
        }
    }
    
    // Total number exercise
    class var numberExercise: String? {
        get {
            return (UserDefaults.standard.value(forKey: "NumberEx") as? String)
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: "NumberEx")
        }
    }
    
    // Total relax time
    class var relaxTime: String? {
        get {
            return (UserDefaults.standard.value(forKey: "RelaxTime") as? String)
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: "RelaxTime")
        }
    }
    
    // ExerciseHadTrain
    class var exerciseHadTrain: [String: [String: String]]? {
        get {
            return (UserDefaults.standard.value(forKey: "ExerciseHadTrain") as? [String: [String: String]])
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: "ExerciseHadTrain")
        }
    }
    
    // Link exercise
    class var linkExercise: [String: String]? {
        get {
            return (UserDefaults.standard.value(forKey: "LinkEx") as? [String: String])
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: "LinkEx")
        }
    }
    
    // Root link exercise
    class var rootEx: String? {
        get {
            return (UserDefaults.standard.value(forKey: "RootLinkEx") as? String)
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: "RootLinkEx")
        }
    }
}
