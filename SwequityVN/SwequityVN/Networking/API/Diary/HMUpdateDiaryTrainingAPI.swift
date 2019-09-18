//
//  HMUpdateDiaryTrainingAPI.swift
//  SwequityVN
//
//  Created by RTC-HN360 on 7/28/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class HMUpdateDiaryTrainingAPI: HMAPIOperation<HMUpdateDiaryTrainingAPIResponse> {
    init(programId: String, exId: String) {
        super.init(request: HMAPIRequest(name: "Update calendar", path: HMURLConstants.updateCalendarAPIPath, method: .post, parameters: .body([
            "id": HMSharedData.userId!,
            "program_id": programId,
            "ex_id": exId])))
    }
}

struct HMUpdateDiaryTrainingAPIResponse:HMAPIResponseProtocol {
    var errorId: Int
    var message: String
    
    init(json: JSON) {
        errorId = json["errorId"].int ?? 0
        message = json["message"].string ?? ""
    }
}
