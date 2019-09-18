//
//  HMAddTrainingSessionAPI.swift
//  SwequityVN
//
//  Created by RTC-HN360 on 7/28/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class HMAddTrainingSessionAPI: HMAPIOperation<HMAddTrainingSessionAPIResponse> {
    init(programId: String, name: String, date: String) {
        super.init(request: HMAPIRequest(name: "Add sesion", path: HMURLConstants.addSessionAPIPath, method: .post, parameters: .body([
            "program_id": programId,
            "name": name,
            "date": date])))
    }
}

struct HMAddTrainingSessionAPIResponse:HMAPIResponseProtocol {
    var errorId: Int
    var message: String
    
    init(json: JSON) {
        errorId = json["errorId"].int ?? 0
        message = json["message"].string ?? ""
    }
}
