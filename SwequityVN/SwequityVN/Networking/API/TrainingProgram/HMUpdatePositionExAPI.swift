//
//  HMUpdatePositionExAPI.swift
//  SwequityVN
//
//  Created by RTC-HN360 on 7/28/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class HMUpdatePositionExAPI: HMAPIOperation<HMUpdatePositionExAPIResponse> {
    init(sessionId: String, exId: String) {
        super.init(request: HMAPIRequest(name: "Update position", path: HMURLConstants.updatePositionAPIPath, method: .post, parameters: .body([
            "session_id": sessionId,
            "ex_id": exId])))
    }
    
    init(sessionId: String, exId: String, numberSets: String) {
        super.init(request: HMAPIRequest(name: "Update position and set", path: HMURLConstants.updateWorkingAPIPath, method: .post, parameters: .body([
            "session_id": sessionId,
            "ex_id": exId,
            "number_sets": numberSets])))
    }
}

struct HMUpdatePositionExAPIResponse:HMAPIResponseProtocol {
    var errorId: Int
    var message: String
    
    init(json: JSON) {
        errorId = json["errorId"].int ?? 0
        message = json["message"].string ?? ""
    }
}
