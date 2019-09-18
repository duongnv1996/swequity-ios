//
//  HMExerciseFavouriteListAPI.swift
//  SwequityVN
//
//  Created by RTC-HN360 on 7/28/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class HMExerciseFavouriteListAPI: HMAPIOperation<HMExerciseFavouriteListAPIResponse> {
    init(categoryId: String? = nil) {
        var parameters = ["id": HMSharedData.userId!]
        if let categoryId = categoryId {
            parameters["category_id"] = categoryId
        }
        super.init(request: HMAPIRequest(name: "Favourite exercise list", path: HMURLConstants.listFavouriteAPIPath, method: .get, parameters: .body(parameters)))
    }
}

struct HMExerciseFavouriteListAPIResponse:HMAPIResponseProtocol {
    var errorId: Int
    var message: String
    var favouriteList: [HMExDetailEntity] = []
    
    init(json: JSON) {
        errorId = json["errorId"].int ?? 0
        message = json["message"].string ?? ""
        do {
            favouriteList = try json["data"].arrayValue.map({
                let data = try $0.rawData(options: .prettyPrinted)
                return try JSONDecoder().decode(HMExDetailEntity.self, from: data)
            })
        } catch {
            print(error)
        }
    }
}
