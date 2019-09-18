//
//  HMTotalWeightSesstionAPI.swift
//  SwequityVN
//
//  Created by RTC-HN360 on 7/28/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class HMTotalWeightSesstionAPI: HMAPIOperation<HMTotalWeightSesstionAPIResponse> {
    init(sessionId: String) {
        super.init(request: HMAPIRequest(name: "Total weight", path: HMURLConstants.totalWeightAPIPath, method: .get, parameters: .body([
            "session_id": sessionId])))
    }
}

struct HMTotalWeightSesstionAPIResponse:HMAPIResponseProtocol {
    var errorId: Int
    var message: String
    var totalWeight: String
    init(json: JSON) {
        errorId = json["errorId"].int ?? 0
        message = json["message"].string ?? ""
        totalWeight = json["data"].string ?? ""
    }
}
