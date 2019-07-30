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
    init(id: String) {
        super.init(request: HMAPIRequest(name: "Favourite exercise list", path: HMURLConstants.listFavouriteAPIPath, method: .get, parameters: .body([
            "id_user": HMSharedData.userId!,
            "category_id": id])))
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
