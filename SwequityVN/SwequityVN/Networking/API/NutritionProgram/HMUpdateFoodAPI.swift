//
//  HMUpdateFoodAPI.swift
//  SwequityVN
//
//  Created by RTC-HN360 on 8/6/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class HMUpdateFoodAPI: HMAPIOperation<HMUpdateFoodAPIResponse> {
    init(value: String, type: HMNutritonType) {
        super.init(request: HMAPIRequest(name: "Update food", path: HMURLConstants.updateFoodAPIPath, method: .post, parameters: .body([
            "user_id": HMSharedData.userId!,
            "value": value,
            "type": type])))
    }
}

struct HMUpdateFoodAPIResponse:HMAPIResponseProtocol {
    var errorId: Int
    var message: String
    
    init(json: JSON) {
        errorId = json["errorId"].int ?? 0
        message = json["message"].string ?? ""
    }
}
