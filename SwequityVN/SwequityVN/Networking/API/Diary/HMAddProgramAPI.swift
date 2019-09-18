//
//  HMAddProgramAPI.swift
//  SwequityVN
//
//  Created by Nguyễn Nam on 8/4/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class HMAddProgramAPI: HMAPIOperation<HMAddProgramAPIResponse> {
    init(title: String, startDate: String, endDate: String) {
        super.init(request: HMAPIRequest(name: "Add Program", path: HMURLConstants.addProgramAPIPath, method: .post, parameters: .body([
            "user_id": HMSharedData.userId!,
            "title": title,
            "date_start": startDate,
            "date_end": endDate
            ])))
    }
}

struct HMAddProgramAPIResponse:HMAPIResponseProtocol {
    var errorId: Int
    var message: String
    var programId: Int
    
    init(json: JSON) {
        errorId = json["errorId"].int ?? 0
        message = json["message"].string ?? ""
        programId = json["data"].int ?? 0
    }
}
