//
//  HMFoodListAPI.swift
//  SwequityVN
//
//  Created by RTC-HN360 on 7/28/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class HMFoodListAPI: HMAPIOperation<HMFoodListAPIResponse> {
    init() {
        super.init(request: HMAPIRequest(name: "Food list", path: HMURLConstants.listFoodAPIPath, method: .get, parameters: .body([
            "id": HMSharedData.userId!])))
    }
}

struct HMFoodListAPIResponse:HMAPIResponseProtocol {
    var errorId: Int
    var message: String
    var foodList: HMFoodListEntity?
    
    init(json: JSON) {
        errorId = json["errorId"].int ?? 0
        message = json["message"].string ?? ""
        do {
            let data = try json["data"].rawData(options: .prettyPrinted)
            foodList = try JSONDecoder().decode(HMFoodListEntity.self, from: data)
        } catch {
            print(error)
        }
    }
}

