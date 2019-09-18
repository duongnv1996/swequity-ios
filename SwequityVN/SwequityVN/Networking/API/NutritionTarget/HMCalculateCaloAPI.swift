//
//  HMCalculateCaloAPI.swift
//  SwequityVN
//
//  Created by RTC-HN360 on 7/28/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class HMCalculateCaloAPI: HMAPIOperation<HMCalculateCaloAPIResponse> {
    init(idFood: String) {
        super.init(request: HMAPIRequest(name: "Calculate calo", path: HMURLConstants.calAPIPath, method: .get, parameters: .body([
            "id_food": idFood,
            "user_id": HMSharedData.userId!])))
    }
}

struct HMCalculateCaloAPIResponse:HMAPIResponseProtocol {
    var errorId: Int
    var message: String
    var calEntity: HMCalEntity?
    
    init(json: JSON) {
        errorId = json["errorId"].int ?? 0
        message = json["message"].string ?? ""
        
        do {
            let data = try json["data"].rawData(options: .prettyPrinted)
            calEntity = try JSONDecoder().decode(HMCalEntity.self, from: data)
        } catch {
            print(error)
        }
    }
}
