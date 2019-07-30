//
//  HMLoginAPI.swift
//  Develop
//
//  Created by RTC-HN360 on 7/25/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class HMLoginAPI: HMAPIOperation<HMLoginAPIResponse> {
    init(username: String, password: String) {
        super.init(request: HMAPIRequest(name: "Login", path: HMURLConstants.loginAPIPath, method: .get, parameters: .body([
            "username": username,
            "password": password,
            "type": HMConstants.userType])))
    }
}

struct HMLoginAPIResponse: HMAPIResponseProtocol {
    var errorId: Int
    var message: String
    var userInfo: HMUserInfoEntity? = nil
    
    init(json: JSON) {
        errorId = json["errorId"].int ?? 0
        message = json["message"].string ?? ""
        
        do {
            let data = try json["data"].rawData(options: .prettyPrinted)
            userInfo = try JSONDecoder().decode(HMUserInfoEntity.self, from: data)
//            HMSharedData.driverId = driverInfo?.id
//            HMSharedData.serviceId = driverInfo?.service_id
//            HMSharedData.active = driverInfo?.active
//            HMRealmService.instance.write { (realm) in
//                let userInfoRealm = HMUserInfoRealm()
//                userInfoRealm.userId = driverInfo?.id
//                userInfoRealm.userName = driverInfo?.name
//                userInfoRealm.avatar = driverInfo?.avatar
//                userInfoRealm.phone = driverInfo?.phone
//                userInfoRealm.email = driverInfo?.email
//                userInfoRealm.amount = driverInfo?.account
//                userInfoRealm.rating = driverInfo?.account
//                userInfoRealm.bienso = driverInfo?.bienso
//                userInfoRealm.serviceId = driverInfo?.service_id
//                realm.add(userInfoRealm, update: true)
//            }
            HMOneSignalNotificationService.shared.sendTag(userId: userInfo?.id)
        } catch {
            print(error)
        }
    }
}
