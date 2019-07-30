//
//  HMExerciseFavoriteAPI.swift
//  SwequityVN
//
//  Created by RTC-HN360 on 7/28/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class HMExerciseFavouriteAPI: HMAPIOperation<HMExerciseFavoriteAPIResponse> {
    init(id: String, type: HMFavouriteType) {
        super.init(request: HMAPIRequest(name: "Favourite exercise", path: HMURLConstants.favouriteAPIPath, method: .post, parameters: .body(["id_user": HMSharedData.userId!,
            "id_ex": id,
            "type": type])))
    }
}

struct HMExerciseFavoriteAPIResponse:HMAPIResponseProtocol {
    var errorId: Int
    var message: String
    
    init(json: JSON) {
        errorId = json["errorId"].int ?? 0
        message = json["message"].string ?? ""
    }
}
