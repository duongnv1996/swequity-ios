//
//  HMFavouriteFoodListAPI.swift
//  SwequityVN
//
//  Created by RTC-HN360 on 7/28/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class HMFavouriteFoodListAPI: HMAPIOperation<HMFavouriteFoodListAPIResponse> {
    init() {
        super.init(request: HMAPIRequest(name: "List favourite food", path: HMURLConstants.listFavouriteFoodAPIPath, method: .get, parameters: .body([
            "id": HMSharedData.userId!])))
    }
}

struct HMFavouriteFoodListAPIResponse:HMAPIResponseProtocol {
    var errorId: Int
    var message: String
    var favouriteList:[HMFoodDetailEntity] = []
    
    init(json: JSON) {
        errorId = json["errorId"].int ?? 0
        message = json["message"].string ?? ""
        do {
            favouriteList = try json["data"].arrayValue.map({
                let data = try $0.rawData(options: .prettyPrinted)
                return try JSONDecoder().decode(HMFoodDetailEntity.self, from: data)
            })
        } catch {
            print(error)
        }
    }
}
