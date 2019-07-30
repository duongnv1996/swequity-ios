//
//  HMNotificationListAPI.swift
//  Develop
//
//  Created by RTC-HN360 on 7/27/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class HMNotificationListAPI: HMAPIOperation<HMNotificationListAPIResponse> {
    init() {
        super.init(request: HMAPIRequest(name: "List Notificaiton", path: HMURLConstants.notificationAPIPath, method: .get, parameters: .body([
            "id" : HMSharedData.userId!])))
    }
}

struct HMNotificationListAPIResponse: HMAPIResponseProtocol  {
    var errorId: Int
    var message: String
    var listNotifications: [HMNotificationDetailEntity] = []
    
    init(json: JSON) {
        errorId = json["errorId"].int ?? 0
        message = json["message"].string ?? ""
        do {
            listNotifications = try json["data"].arrayValue.map({
                let data = try $0.rawData(options: .prettyPrinted)
                return try JSONDecoder().decode(HMNotificationDetailEntity.self, from: data)
            })
        } catch {
            print(error)
        }
    }
}
