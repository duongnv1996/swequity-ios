
//
//  HMDeleteProgramAPI.swift
//  SwequityVN
//
//  Created by RTC-HN360 on 7/28/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class HMDeleteProgramAPI: HMAPIOperation<HMDeleteProgramAPIResponse> {
    init(courseId: String) {
        super.init(request: HMAPIRequest(name: "Delete program", path: HMURLConstants.deleteCourseAPIPath, method: .post, parameters: .body([
            "course_id": courseId,
            "user_id": HMSharedData.userId!])))
    }
}

struct HMDeleteProgramAPIResponse:HMAPIResponseProtocol {
    var errorId: Int
    var message: String
    
    init(json: JSON) {
        errorId = json["errorId"].int ?? 0
        message = json["message"].string ?? ""
    }
}
