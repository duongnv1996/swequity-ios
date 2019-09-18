//
//  HMFavouriteFoodAPI.swift
//  SwequityVN
//
//  Created by RTC-HN360 on 7/28/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class HMFavouriteFoodAPI: HMAPIOperation<HMFavouriteFoodAPIResponse> {
    init(idFood: String, type: String) {
        super.init(request: HMAPIRequest(name: "Favourite food", path: HMURLConstants.favouriteFoodAPIPath, method: .post, parameters: .body([
            "id_user": HMSharedData.userId!,
            "id_food": idFood,
            "type": type])))
    }
}

struct HMFavouriteFoodAPIResponse:HMAPIResponseProtocol {
    var errorId: Int
    var message: String
    
    init(json: JSON) {
        errorId = json["errorId"].int ?? 0
        message = json["message"].string ?? ""
    }
}
