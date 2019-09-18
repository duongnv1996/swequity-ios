//
//  HMDeleteSessionAPI.swift
//  SwequityVN
//
//  Created by RTC-HN360 on 7/28/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class HMDeleteExInSessionAPI: HMAPIOperation<HMDeleteExInSessionAPIResponse> {
    init(id: String) {
        super.init(request: HMAPIRequest(name: "Delete ex", path: HMURLConstants.deleteExAPIPath, method: .post, parameters: .body(["id": id])))
    }
}

struct HMDeleteExInSessionAPIResponse:HMAPIResponseProtocol {
    var errorId: Int
    var message: String
    
    init(json: JSON) {
        errorId = json["errorId"].int ?? 0
        message = json["message"].string ?? ""
    }
}
