//
//  HMPrivacyAPI.swift
//  Develop
//
//  Created by RTC-HN360 on 7/27/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class HMPrivacyAPI: HMAPIOperation<HMPrivacyAPIResponse> {
    init() {
        super.init(request: HMAPIRequest(name: "Privacy", path: HMURLConstants.privacyAPIPath, method: .get, parameters: .body([:])))
    }
}

struct HMPrivacyAPIResponse: HMAPIResponseProtocol {
    var errorId: Int
    var message: String
    var privacy: HMPrivacyEntity?
    
    init(json: JSON) {
        errorId = json["errorId"].int ?? 0
        message = json["message"].string ?? ""
        do {
            let data = try json["data"].rawData(options: .prettyPrinted)
            privacy = try JSONDecoder().decode(HMPrivacyEntity.self, from: data)
        } catch {
            print(error)
        }
    }
}
