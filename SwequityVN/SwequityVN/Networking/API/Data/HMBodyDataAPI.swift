//
//  HMBodyDataAPI.swift
//  SwequityVN
//
//  Created by RTC-HN360 on 7/28/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class HMBodyDataAPI: HMAPIOperation<HMBodyDataAPIResponse> {
    init(numberMonth: String, key: String) {
        super.init(request: HMAPIRequest(name: "Body data", path: HMURLConstants.dataBodyAPIPath, method: .get, parameters: .body([
            "user_id": HMSharedData.userId!,
            "number_month": numberMonth,
            "key": key])))
    }
}

struct HMBodyDataAPIResponse:HMAPIResponseProtocol {
    var errorId: Int
    var message: String
    var bodyData: [HMBodyDataWithMonthEntity] = []
    
    init(json: JSON) {
        errorId = json["errorId"].int ?? 0
        message = json["message"].string ?? ""
        
        do {
            bodyData = try json["data"].arrayValue.map({
                let data = try $0.rawData(options: .prettyPrinted)
                return try JSONDecoder().decode(HMBodyDataWithMonthEntity.self, from: data)
            })
        } catch {
            print(error)
        }
    }
}
