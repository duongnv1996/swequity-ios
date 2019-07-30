//
//  HMVerifyCodeAPI.swift
//  Develop
//
//  Created by RTC-HN360 on 7/26/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class HMVerifyCodeAPI: HMAPIOperation<HMVerifyCodeAPIResponse> {
    init(phoneNumber: String) {
        super.init(request: HMAPIRequest(name: "Verify code", path: HMURLConstants.verifyCodeAPIPath, method: .get, parameters: .body([
            "phone": phoneNumber])))
    }
}

struct HMVerifyCodeAPIResponse: HMAPIResponseProtocol {
    var errorId: Int
    var message: String
    
    init(json: JSON) {
        errorId = json["errorId"].int ?? 0
        message = json["message"].string ?? ""
    }
}
