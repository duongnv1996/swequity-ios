//
//  HMImageDiaryAPI.swift
//  SwequityVN
//
//  Created by RTC-HN360 on 7/27/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class HMImageDiaryAPI: HMAPIOperation<HMImageDiaryAPIResponse> {
    init() {
        super.init(request: HMAPIRequest(name: "Image", path: HMURLConstants.imageAPIPath, method: .get, parameters: .body([
            "id" : HMSharedData.userId!])))
    }
}

struct HMImageDiaryAPIResponse: HMAPIResponseProtocol {
    var errorId: Int
    var message: String
    var bodyImages: HMBodyImageEntity?
    
    init(json: JSON) {
        errorId = json["errorId"].int ?? 0
        message = json["message"].string ?? ""
        do {
            let data = try json["data"].rawData(options: .prettyPrinted)
            bodyImages = try JSONDecoder().decode(HMBodyImageEntity.self, from: data)
        } catch {
            print(error)
        }
    }
}
