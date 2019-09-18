//
//  HMExerciseInDateAPI.swift
//  SwequityVN
//
//  Created by RTC-HN360 on 7/28/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class HMExerciseInDateAPI: HMAPIOperation<HMExerciseInDateAPIResponse> {
    init(date: String) {
        super.init(request: HMAPIRequest(name: "Exersice in date", path: HMURLConstants.detailExByDayAPIPath, method: .get, parameters: .body([
            "user_id": HMSharedData.userId!,
            "date": date])))
    }
}

struct HMExerciseInDateAPIResponse:HMAPIResponseProtocol {
    var errorId: Int
    var message: String
    var exList: [HMExerciseInSessionDetailEntity] = []
    
    init(json: JSON) {
        errorId = json["errorId"].int ?? 0
        message = json["message"].string ?? ""
        do {
            exList = try json["data"].arrayValue.map({
                let data = try $0.rawData(options: .prettyPrinted)
                return try JSONDecoder().decode(HMExerciseInSessionDetailEntity.self, from: data)
            })
        } catch {
            print(error)
        }
    }
}
