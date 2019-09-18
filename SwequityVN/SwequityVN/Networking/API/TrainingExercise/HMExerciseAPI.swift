//
//  HMExerciseAPI.swift
//  SwequityVN
//
//  Created by RTC-HN360 on 7/27/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class HMExerciseAPI: HMAPIOperation<HMExerciseAPIResponse> {
    init(id: String) {
        super.init(request: HMAPIRequest(name: "Exersise detail", path: HMURLConstants.exDetailAPIPath, method: .get, parameters: .body(
            ["id": id])))
    }
}

struct HMExerciseAPIResponse: HMAPIResponseProtocol {
    var errorId: Int
    var message: String
    var exDetail: HMExDetailEntity?
    
    init(json: JSON) {
        errorId = json["errorId"].int ?? 0
        message = json["message"].string ?? ""
        do {
            let data = try json["data"].rawData(options: .prettyPrinted)
            exDetail = try JSONDecoder().decode(HMExDetailEntity.self, from: data)
        } catch {
            print(error)
        }
    }
}
