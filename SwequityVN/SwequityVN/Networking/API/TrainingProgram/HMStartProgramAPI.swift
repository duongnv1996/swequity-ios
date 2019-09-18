//
//  HMStartProgramAPI.swift
//  SwequityVN
//
//  Created by RTC-HN360 on 7/28/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class HMStartProgramAPI: HMAPIOperation<HMStartProgramAPIResponse> {
    init(sessionId: String, programId: String) {
        super.init(request: HMAPIRequest(name: "Start program ex", path: HMURLConstants.startSessionAPIPath, method: .post, parameters: .body([
            "session_id": sessionId,
            "user_id": HMSharedData.userId!,
            "program_id": programId])))
    }
}

struct HMStartProgramAPIResponse:HMAPIResponseProtocol {
    var errorId: Int
    var message: String
    
    init(json: JSON) {
        errorId = json["errorId"].int ?? 0
        message = json["message"].string ?? ""
    }
}
