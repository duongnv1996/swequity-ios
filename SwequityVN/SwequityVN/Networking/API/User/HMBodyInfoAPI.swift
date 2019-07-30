//
//  HMBodyInfoAPI.swift
//  Develop
//
//  Created by RTC-HN360 on 7/27/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class HMBodyInfoAPI: HMAPIOperation<HMBodyInfoAPIResponse> {
    init() {
        super.init(request: HMAPIRequest(name: "Statistic", path: HMURLConstants.statisticAPIPath, method: .get, parameters: .body([
            "id": HMSharedData.userId!])))
    }
}

struct HMBodyInfoAPIResponse: HMAPIResponseProtocol {
    var errorId: Int
    var message: String
    var bodyInfo: HMBodyInfoEntity?
    
    init(json: JSON) {
        errorId = json["errorId"].int ?? 0
        message = json["message"].string ?? ""
        do {
            let data = try json["data"].rawData(options: .prettyPrinted)
            bodyInfo = try JSONDecoder().decode(HMBodyInfoEntity.self, from: data)
        } catch {
            print(error)
        }
    }
}
