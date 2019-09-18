//
//  HMUpdateImageExAPI.swift
//  SwequityVN
//
//  Created by RTC-HN360 on 7/28/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class HMUpdateImageExAPI: HMAPIOperation<HMUpdateImageExAPIResponse> {
    init(exId: String, keyFile: Data) {
        super.init(request: HMAPIRequest(name: "Update image", path: HMURLConstants.updateImageExAPIPath, method: .post, parameters: .body([
            "exId": exId,
            "time": time])))
    }
}

struct HMUpdateImageExAPIResponse:HMAPIResponseProtocol {
    var errorId: Int
    var message: String
    
    init(json: JSON) {
        errorId = json["errorId"].int ?? 0
        message = json["message"].string ?? ""
    }
}
