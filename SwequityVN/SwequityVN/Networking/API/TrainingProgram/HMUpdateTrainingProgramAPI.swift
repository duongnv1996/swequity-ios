//
//  HMUpdateTrainingProgramAPI.swift
//  SwequityVN
//
//  Created by RTC-HN360 on 7/28/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class HMUpdateTrainingProgramAPI: HMAPIOperation<HMUpdateTrainingProgramAPIResponse> {
    init(programId: String, title: String, dateStart: String, dateEnd: String) {
        super.init(request: HMAPIRequest(name: "Update program", path: HMURLConstants.updateProgramAPIPath, method: .post, parameters: .body([
            "program_id": programId,
            "title": title,
            "date_start": dateStart,
            "date_end": dateEnd])))
    }
}

struct HMUpdateTrainingProgramAPIResponse:HMAPIResponseProtocol {
    var errorId: Int
    var message: String
    
    init(json: JSON) {
        errorId = json["errorId"].int ?? 0
        message = json["message"].string ?? ""
    }
}
