//
//  HMProgramDetailAPI.swift
//  SwequityVN
//
//  Created by RTC-HN360 on 7/28/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class HMSessionDetailAPI: HMAPIOperation<HMSessionDetailAPIResponse> {
    init(idSession:String) {
        super.init(request: HMAPIRequest(name: "Session detail", path: HMURLConstants.sessionDetailAPIPath, method: .get, parameters: .body([
            "id": idSession,
            "user_id": HMSharedData.userId!])))
    }
}

struct HMSessionDetailAPIResponse:HMAPIResponseProtocol {
    var errorId: Int
    var message: String
    var listExsInSection: [HMExerciseInSessionDetailEntity] = []
    
    init(json: JSON) {
        errorId = json["errorId"].int ?? 0
        message = json["message"].string ?? ""
        do {
            listExsInSection = try json["data"].arrayValue.map({
                let data = try $0.rawData(options: .prettyPrinted)
                return try JSONDecoder().decode(HMExerciseInSessionDetailEntity.self, from: data)
            })
        } catch {
            print(error)
        }
    }
}
