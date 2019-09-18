//
//  HMExerciseListAPI.swift
//  SwequityVN
//
//  Created by RTC-HN360 on 7/28/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class HMExerciseListAPI: HMAPIOperation<HMExerciseListAPIResponse> {
    init() {
        super.init(request: HMAPIRequest(name: "List exercise", path: HMURLConstants.listCategoryAPIPath, method: .get, parameters: .body([:])))
    }
    
    init(key: String) {
        super.init(request: HMAPIRequest(name: "Search ex with category", path: HMURLConstants.searchCategoryAPIPath, method: .get, parameters: .body([
            "key": key])))
    }
    
    init(id: String) {
        super.init(request: HMAPIRequest(name: "List Exersise with category", path: HMURLConstants.listExAPIPath, method: .get, parameters: .body(
            ["id": id,
             "user_id": HMSharedData.userId!]
            )))
    }
}

struct HMExerciseListAPIResponse:HMAPIResponseProtocol {
    var errorId: Int
    var message: String
    var exList:[HMExDetailEntity] = []
    
    init(json: JSON) {
        errorId = json["errorId"].int ?? 0
        message = json["message"].string ?? ""
        do {
            exList = try json["data"].arrayValue.map({
                let data = try $0.rawData(options: .prettyPrinted)
                return try JSONDecoder().decode(HMExDetailEntity.self, from: data)
            })
        } catch {
            print(error)
        }
    }
}
