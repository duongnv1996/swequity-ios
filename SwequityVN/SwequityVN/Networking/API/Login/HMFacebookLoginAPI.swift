//
//  HMFacebooKLoginAPI.swift
//  SwequityVN
//
//  Created by RTC-HN360 on 7/28/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class HMFacebookLoginAPI: HMAPIOperation<HMFacebookLoginAPIResponse> {
    init(email: String, fbid: String, name: String) {
        super.init(request: HMAPIRequest(name: "Facebook login", path: HMURLConstants.loginFbAPIPath, method: .get, parameters: .body([
            "email": email,
            "fbid": fbid,
            "name": name])))
    }
}

struct HMFacebookLoginAPIResponse: HMAPIResponseProtocol {
    var errorId: Int
    var message: String
    
    init(json: JSON) {
        errorId = json["errorId"].int ?? 0
        message = json["message"].string ?? ""
    }
}
