//
//  HMTargetWeekListAPI.swift
//  SwequityVN
//
//  Created by RTC-HN360 on 7/28/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class HMTargeListAPI: HMAPIOperation<HMTargeListAPIResponse> {
    init(type: HMTargetType) {
        let pathString:String = type.rawValue
        let path:String = type == .action ? HMURLConstants.levelActionAPIPath : HMURLConstants.targetWeekAPIPath
        
        super.init(request: HMAPIRequest(name: "Target \(pathString) list", path: path, method: .get, parameters: .body([:])))
    }
}

struct HMTargeListAPIResponse:HMAPIResponseProtocol {
    var errorId: Int
    var message: String
    var targetList:[HMTargetDetailEntity] = []
    
    init(json: JSON) {
        errorId = json["errorId"].int ?? 0
        message = json["message"].string ?? ""
        do {
            targetList = try json["data"].arrayValue.map({
                let data = try $0.rawData(options: .prettyPrinted)
                return try JSONDecoder().decode(HMTargetDetailEntity.self, from: data)
            })
        } catch {
            print(error)
        }
    }
}
