//
//  HMAddTrainingProgramAPI.swift
//  SwequityVN
//
//  Created by RTC-HN360 on 7/28/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class HMAddTrainingProgramAPI: HMAPIOperation<HMAddTrainingProgramAPIResponse> {
    init(title: String, dateStart: String, dateEnd: String) {
        super.init(request: HMAPIRequest(name: "Add program", path: HMURLConstants.addProgramAPIPath, method: .post, parameters: .body([
            "id": HMSharedData.userId!,
            "title": title,
            "date_start": dateStart,
            "date_end": dateEnd])))
    }
}

struct HMAddTrainingProgramAPIResponse:HMAPIResponseProtocol {
    var errorId: Int
    var message: String
    
    init(json: JSON) {
        errorId = json["errorId"].int ?? 0
        message = json["message"].string ?? ""
    }
}
