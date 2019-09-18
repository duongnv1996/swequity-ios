//
//  HMUpdateBodyImageAPI.swift
//  SwequityVN
//
//  Created by RTC-HN360 on 7/27/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class HMUpdateBodyImageAPI: HMAPIOperation<HMUpdateBodyImageAPIResponse> {
    init(image: Data, type: HMImageType) {
        super.init(request: HMAPIRequest(name: "Update body image", path: HMURLConstants.updateImageAPIPath, method: .post, parameters:
            .multipart(data: image, parameters: [
                "id": HMSharedData.userId!,
                "type": type.rawValue], name: "img", fileName: "\(HMSharedData.userId!)_\(UUID().uuidString)_image.jpg", mimeType: "jpg")))
    }
}

struct HMUpdateBodyImageAPIResponse: HMAPIResponseProtocol {
    var errorId: Int
    var message: String
    
    init(json: JSON) {
        errorId = json["errorId"].int ?? 0
        message = json["message"].string ?? ""
    }
}
