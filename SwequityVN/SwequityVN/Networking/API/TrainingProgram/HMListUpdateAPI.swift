//
//  HMListUpdateAPI.swift
//  SwequityVN
//
//  Created by RTC-HN360 on 7/28/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class HMListUpdateAPI: HMAPIOperation<HMListUpdateAPIResponse> {
    init() {
        super.init(request: HMAPIRequest(name: "List update", path: HMURLConstants.listUpdateAPIPath, method: .get, parameters: .body([
            "user_id": HMSharedData.userId!])))
    }
}

struct HMListUpdateAPIResponse:HMAPIResponseProtocol {
    var errorId: Int
    var message: String
    var bodyInfo:HMBodyInfoEntity?
    
    init(json: JSON) {
        errorId = json["errorId"].int ?? 0
        message = json["message"].string ?? ""
        do {
            let data = try json["data"].rawData(options: .prettyPrinted)
            bodyInfo = try JSONDecoder().decode(HMBodyInfoEntity.self, from: data)
        } catch {
            print(error)
        }
    }
}
