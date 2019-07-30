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
                "type": type], name: "img", fileName: "\(HMSharedData.userId!)_image.jpg", mimeType: "jpg")))
    }
}

struct HMUpdateBodyImageAPIResponse: HMAPIResponseProtocol {
    var errorId: Int
    var message: String
    var bodyInfo: HMBodyInfoEntity?
    
    init(json: JSON) {
        errorId = json["errorId"].int ?? 0
        message = json["message"].string ?? ""
        do {
            let data = try json["data"].rawData(options: .prettyPrinted)
            bodyInfo = try JSONDecoder().decode(HMBodyInfoEntity.self, from: data)
        } catch {
            print(error)
        }
    }
}
