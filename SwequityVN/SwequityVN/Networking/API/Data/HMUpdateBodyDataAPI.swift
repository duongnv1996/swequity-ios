//
//  HMUpdateBodyDataAPI.swift
//  Develop
//
//  Created by RTC-HN360 on 7/27/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class HMUpdateBodyDataAPI: HMAPIOperation<HMUpdateBodyDataAPIResponse> {
    init(khoiluong: String, khoiluongmo: String, khoiluongnac: String, nguc: String, vai: String,
         baptrai: String, bapphai: String,
         cangtaytrai: String, cangtayphai: String, eo: String, mong: String, bungngangron: String, duitrai: String, duiphai: String, bapchuoitrai: String, bapchuoiphai: String) {
        super.init(request: HMAPIRequest(name: "Statistic", path: HMURLConstants.statisticAPIPath, method: .post, parameters: .body([
            "id": HMSharedData.userId!,
            "khoiluong": khoiluong,
            "khoiluongmo": khoiluongmo,
            "khoiluongnac": khoiluongnac,
            "nguc": nguc,
            "vai": vai,
            "baptrai": baptrai,
            "bapphai": bapphai,
            "cangtaytrai": cangtaytrai,
            "cangtayphai": cangtayphai,
            "eo": eo,
            "mong": mong,
            "bungngangron": bungngangron,
            "duitrai": duitrai,
            "duiphai": duiphai,
            "bapchuoitrai": bapchuoitrai,
            "bapchuoiphai": bapchuoiphai])))
    }
}

struct HMUpdateBodyDataAPIResponse: HMAPIResponseProtocol {
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
