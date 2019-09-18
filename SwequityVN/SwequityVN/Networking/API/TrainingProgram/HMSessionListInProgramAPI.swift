//
//  HMSessionListInProgramAPI.swift
//  SwequityVN
//
//  Created by RTC-HN360 on 7/28/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class HMSessionListInProgramAPI: HMAPIOperation<HMSessionListInProgramAPIResponse> {
    init(idProgram: String) {
        super.init(request: HMAPIRequest(name: "List session in program", path: HMURLConstants.listSessionAPIPath, method: .get, parameters: .body([
            "id": idProgram])))
    }
}

struct HMSessionListInProgramAPIResponse:HMAPIResponseProtocol {
    var errorId: Int
    var message: String
    var sessionList:[HMSessionExDetailEntity] = []
    
    init(json: JSON) {
        errorId = json["errorId"].int ?? 0
        message = json["message"].string ?? ""
        do {
            sessionList = try json["data"].arrayValue.map({
                let data = try $0.rawData(options: .prettyPrinted)
                return try JSONDecoder().decode(HMSessionExDetailEntity.self, from: data)
            })
        } catch {
            print(error)
        }
    }
}
