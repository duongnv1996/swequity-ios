//
//  HMForgetPasswordAPI.swift
//  Develop
//
//  Created by RTC-HN360 on 7/26/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class HMForgetPasswordAPI: HMAPIOperation<HMForgetPasswordAPIResponse> {
    init(phone: String) {
        super.init(request: HMAPIRequest(name: "Forget password", path: HMURLConstants.forgetPasswordAPIPath, method: .post, parameters: .body([
            "phone": phone,
            "type":HMConstants.userType])))
    }
}

struct HMForgetPasswordAPIResponse: HMAPIResponseProtocol {
    var errorId: Int
    var message: String
    
    init(json: JSON) {
        errorId = json["errorId"].int ?? 0
        message = json["message"].string ?? ""
    }
}
