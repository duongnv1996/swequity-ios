//
//  HMExerciseInSessionDetailAPI.swift
//  SwequityVN
//
//  Created by RTC-HN360 on 7/28/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class HMExerciseInSessionDetailAPI: HMAPIOperation<HMExerciseInSessionDetailAPIResponse> {
    init(sessionId: String, exId: String) {
        super.init(request: HMAPIRequest(name: "Detail ex in session", path: HMURLConstants.detailExAPIPath, method: .get, parameters: .body([
            "session_id": sessionId,
            "ex_id": exId])))
    }
}

struct HMExerciseInSessionDetailAPIResponse:HMAPIResponseProtocol {
    var errorId: Int
    var message: String
    var listEx: [HMSetsDetailEntity] = []
    
    init(json: JSON) {
        errorId = json["errorId"].int ?? 0
        message = json["message"].string ?? ""
        
        do {
            listEx = try json["data"].arrayValue.map({
                let data = try $0.rawData(options: .prettyPrinted)
                return try JSONDecoder().decode(HMSetsDetailEntity.self, from: data)
            })
        } catch {
            print(error)
        }
    }
}
