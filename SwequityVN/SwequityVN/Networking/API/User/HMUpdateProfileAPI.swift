//
//  HMUpdateProfileAPI.swift
//  Develop
//
//  Created by RTC-HN360 on 7/26/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class HMUpdateProfileAPI: HMAPIOperation<HMUpdateProfileAPIResponse> {
    init(name: String, birthday: String, weight: Float, id: String, height: Float, gender: Int, address: String, password: String = "", email: String) {
        super.init(request: HMAPIRequest(name: "Update profile", path: HMURLConstants.statisticAPIPath, method: .post, parameters: .body([
            "name": name,
            "birthday": birthday,
            "weight": weight,
            "id": HMSharedData.userId!,
            "height": height,
            "gender": gender,
            "address": address,
            "password": password,
            "email": email])))
    }
}

struct HMUpdateProfileAPIResponse: HMAPIResponseProtocol {
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
