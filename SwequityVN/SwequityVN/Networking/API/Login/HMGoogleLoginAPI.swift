//
//  HMGoogleLoginAPI.swift
//  SwequityVN
//
//  Created by RTC-HN360 on 7/28/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class HMGoogleLoginAPI: HMAPIOperation<HMGoogleLoginAPIResponse> {
    init(email: String, ggid: String, name: String) {
        super.init(request: HMAPIRequest(name: "Login google", path: HMURLConstants.loginggAPIPath, method: .get, parameters: .body([
            "email": email,
            "ggid": ggid,
            "name": name])))
    }
}

struct HMGoogleLoginAPIResponse:HMAPIResponseProtocol {
    var errorId: Int
    var message: String
    var userInfo: HMUserInfoEntity? = nil
    
    init(json: JSON) {
        errorId = json["errorId"].int ?? 0
        message = json["message"].string ?? ""
        
        do {
            let data = try json["data"].rawData(options: .prettyPrinted)
            userInfo = try JSONDecoder().decode(HMUserInfoEntity.self, from: data)
            HMSharedData.userId = userInfo?.id
            HMSharedData.active = userInfo?.active
            HMRealmService.instance.write { (realm) in
                let userInfoRealm = HMUserInfoRealm()
                userInfoRealm.userId = userInfo?.id
                userInfoRealm.userName = userInfo?.name
                userInfoRealm.avatar = userInfo?.avatar
                userInfoRealm.phone = userInfo?.phone
                userInfoRealm.email = userInfo?.email
                userInfoRealm.type = userInfo?.type
                realm.add(userInfoRealm, update: true)
            }
            HMOneSignalNotificationService.shared.sendTag(userId: userInfo?.id)
        } catch {
            print(error)
        }
    }
}
