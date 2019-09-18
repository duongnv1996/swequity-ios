
//
//  HMJoinExAPI.swift
//  SwequityVN
//
//  Created by RTC-HN360 on 7/28/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class HMJoinExAPI: HMAPIOperation<HMJoinExAPIResponse> {
    init(sessionId: String, exId: String) {
        super.init(request: HMAPIRequest(name: "Join ex", path: HMURLConstants.joinExAPIPath, method: .post, parameters: .body([
            "session_id": sessionId,
            "ex_id": exId])))
    }
}

struct HMJoinExAPIResponse:HMAPIResponseProtocol {
    var errorId: Int
    var message: String
    
    init(json: JSON) {
        errorId = json["errorId"].int ?? 0
        message = json["message"].string ?? ""
    }
}
