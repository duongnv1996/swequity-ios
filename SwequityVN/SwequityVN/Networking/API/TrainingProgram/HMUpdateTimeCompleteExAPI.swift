//
//  HMUpdateTimeCompleteExAPI.swift
//  SwequityVN
//
//  Created by RTC-HN360 on 7/28/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class HMUpdateTimeCompleteExAPI: HMAPIOperation<HMUpdateTimeCompleteExAPIResponse> {
    init(sessionId: String, exId: String, time: String) {
        super.init(request: HMAPIRequest(name: "Update time", path: HMURLConstants.updateTimeFinishAPIPath, method: .post, parameters: .body([
            "session_id": sessionId,
            "ex_id": exId,
            "time": time])))
    }
}

struct HMUpdateTimeCompleteExAPIResponse:HMAPIResponseProtocol {
    var errorId: Int
    var message: String
    
    init(json: JSON) {
        errorId = json["errorId"].int ?? 0
        message = json["message"].string ?? ""
    }
}
