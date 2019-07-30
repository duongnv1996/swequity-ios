//
//  HMNotificationDetailAPI.swift
//  Develop
//
//  Created by RTC-HN360 on 7/27/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class HMNotificationDetailAPI: HMAPIOperation<HMNotificationDetailAPIResponse> {
    init(id: String) {
        super.init(request: HMAPIRequest(name: "Notificaiton detail", path: HMURLConstants.notificationAPIPath, method: .get, parameters: .body([
            "id" : id,
            "user_id" : HMSharedData.userId!])))
    }
}

struct HMNotificationDetailAPIResponse:HMAPIResponseProtocol {
    var errorId: Int
    var message: String
    var notificationDetail: HMNotificationDetailEntity?
    
    init(json: JSON) {
        errorId = json["errorId"].int ?? 0
        message = json["message"].string ?? ""
        do {
            let data = try json["data"].rawData(options: .prettyPrinted)
            notificationDetail = try JSONDecoder().decode(HMNotificationDetailEntity.self, from: data)
        } catch {
            print(error)
        }
    }
}
