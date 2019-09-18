//
//  HMUpdateExInSessionAPI.swift
//  SwequityVN
//
//  Created by RTC-HN360 on 7/28/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class HMUpdateExInSessionAPI: HMAPIOperation<HMUpdateExInSessionAPIResponse> {
    init(parameter: Parameters) {
        super.init(request: HMAPIRequest(name: "Update ex", path: HMURLConstants.updateExAPIPath, method: .post, parameters: .body(parameter)))
    }
}

struct HMUpdateExInSessionAPIResponse:HMAPIResponseProtocol {
    var errorId: Int
    var message: String
    
    init(json: JSON) {
        errorId = json["errorId"].int ?? 0
        message = json["message"].string ?? ""
    }
}
