//
//  HMGoogleLoginAPI.swift
//  SwequityVN
//
//  Created by RTC-HN360 on 7/28/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class HMGoogleLoginAPI: HMAPIOperation<HMGoogleLoginAPIResponse> {
    init(email: String, ggid: String, name: String) {
        super.init(request: HMAPIRequest(name: "Login google", path: HMURLConstants.loginggAPIPath, method: .get, parameters: .body([
            "email": email,
            "ggid": ggid,
            "name": name])))
    }
}

struct HMGoogleLoginAPIResponse:HMAPIResponseProtocol {
    var errorId: Int
    var message: String
    
    init(json: JSON) {
        errorId = json["errorId"].int ?? 0
        message = json["message"].string ?? ""
    }
}
