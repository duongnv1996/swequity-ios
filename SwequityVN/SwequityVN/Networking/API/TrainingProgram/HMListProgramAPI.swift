//
//  HMListProgramAPI.swift
//  Develop
//
//  Created by RTC-HN360 on 7/28/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class HMListProgramAPI: HMAPIOperation<HMListProgramAPIResponse> {
    init() {
        super.init(request: HMAPIRequest(name: "Get list program", path: HMURLConstants.listProgramAPIPath, method: .get, parameters: .body([
            "id": HMSharedData.userId!])))
    }
}

struct HMListProgramAPIResponse:HMAPIResponseProtocol {
    var errorId: Int
    var message: String
    var programList:[HMProgramExDetailEntity] = []
    
    init(json: JSON) {
        errorId = json["errorId"].int ?? 0
        message = json["message"].string ?? ""
        do {
            programList = try json["data"].arrayValue.map({
                let data = try $0.rawData(options: .prettyPrinted)
                return try JSONDecoder().decode(HMProgramExDetailEntity.self, from: data)
            })
        } catch {
            print(error)
        }
    }
}
