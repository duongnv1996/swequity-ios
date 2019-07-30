//
//  HMTermAPI.swift
//  Develop
//
//  Created by RTC-HN360 on 7/27/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class HMTermAPI: HMAPIOperation<HMTermAPIResponse> {
    init() {
        super.init(request: HMAPIRequest(name: "Term", path: HMURLConstants.termAPIPath, method: .get, parameters: .body([:])))
    }
}

struct HMTermAPIResponse: HMAPIResponseProtocol {
    var errorId: Int
    var message: String
    var term: HMTermEntity?
    
    init(json: JSON) {
        errorId = json["errorId"].int ?? 0
        message = json["message"].string ?? ""
        do {
            let data = try json["data"].rawData(options: .prettyPrinted)
            term = try JSONDecoder().decode(HMTermEntity.self, from: data)
        } catch {
            print(error)
        }
    }
}
