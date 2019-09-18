//
//  HMAddExerciseInSessionAPI.swift
//  Develop
//
//  Created by RTC-HN360 on 7/28/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class HMAddExerciseInSessionAPI: HMAPIOperation<HMAddExerciseInSessionAPIResponse> {
    init(sessionId: String, exId: String) {
        super.init(request: HMAPIRequest(name: "Add exercise", path: HMURLConstants.addExAPIPath, method: .post, parameters: .body([
            "session_id": sessionId,
            "ex_id": exId])))
    }
}

struct HMAddExerciseInSessionAPIResponse:HMAPIResponseProtocol {
    var errorId: Int
    var message: String
    
    init(json: JSON) {
        errorId = json["errorId"].int ?? 0
        message = json["message"].string ?? ""
    }
}
