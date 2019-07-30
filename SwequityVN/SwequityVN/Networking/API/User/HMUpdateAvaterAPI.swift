//
//  HMUpdateAvaterAPI.swift
//  Develop
//
//  Created by RTC-HN360 on 7/27/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class HMUpdateAvaterAPI: HMAPIOperation<HMUpdateAvaterAPIResponse> {
    init(image: Data) {
        super.init(request: HMAPIRequest(name: "Update avatar", path: HMURLConstants.updateProfileAPIPath, method: .post, parameters:
            .multipart(data: image, parameters: [
                "id": HMSharedData.userId!
                ], name: "img", fileName: "\(HMSharedData.userId!)_image.jpg", mimeType: "jpg")))
    }
}

struct HMUpdateAvaterAPIResponse: HMAPIResponseProtocol {
    var errorId: Int
    var message: String
    var url: String?
    
    init(json: JSON) {
        errorId = json["errorId"].int ?? 0
        message = json["message"].string ?? ""
        url = json["data"].string
    }
}
