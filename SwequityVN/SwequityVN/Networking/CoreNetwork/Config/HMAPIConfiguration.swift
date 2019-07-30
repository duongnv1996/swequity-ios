//
//  HMAPIConfiguration.swift
//  TimXe
//
//  Created by NamNH-D1 on 5/28/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class HMAPIConfiguration {

    static var baseUrl: String {
        #if DEVELOP || STAGING
        return "http://swequitydemo.site/api"
        #else
        return "http://swequitydemo.site/api"
        #endif
    }
    
    static var httpHeaders: HTTPHeaders {
        return ["APIkey": HMConstants.apiKey]
    }
    
    static var encoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    static var timeout: TimeInterval {
        return 30
    }
}
