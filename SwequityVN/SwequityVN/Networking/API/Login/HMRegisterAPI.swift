//
//  HMRegisterAPI.swift
//  Develop
//
//  Created by RTC-HN360 on 7/26/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class HMRegisterAPI: HMAPIOperation<HMRegisterAPIResponse> {
    init(phone: String, password: String) {
        super.init(request: HMAPIRequest(name: "Register", path: HMURLConstants.registerAPIPath, method: .post, parameters: .body([
            "phone": phone,
            "password": password])))
    }
}

struct HMRegisterAPIResponse: HMAPIResponseProtocol {
    var errorId: Int
    var message: String
    
    init(json: JSON) {
        errorId = json["errorId"].int ?? 0
        message = json["message"].string ?? ""
    }
}
