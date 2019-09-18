//
//  HMCategoryAPI.swift
//  SwequityVN
//
//  Created by RTC-HN360 on 7/27/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class HMCategoryAPI: HMAPIOperation<HMCategoryAPIResponse> {
    init() {
        super.init(request: HMAPIRequest(name: "Category", path: HMURLConstants.categoryAPIPath, method: .get, parameters: .body([:])))
    }
}

struct HMCategoryAPIResponse: HMAPIResponseProtocol {
    var errorId: Int
    var message: String
    var categoryList: [HMCategoryExEntity] = []
    
    init(json: JSON) {
        errorId = json["errorId"].int ?? 0
        message = json["message"].string ?? ""
        do {
            categoryList = try json["data"].arrayValue.map({
                let data = try $0.rawData(options: .prettyPrinted)
                return try JSONDecoder().decode(HMCategoryExEntity.self, from: data)
            })
        } catch {
            print(error)
        }
    }
}
