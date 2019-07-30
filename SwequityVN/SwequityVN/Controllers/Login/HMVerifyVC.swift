//
//  HMVerifyVC.swift
//  Develop
//
//  Created by RTC-HN360 on 7/25/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit

class HMVerifyVC: HMBaseVC {

    var phoneNumber:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func didTappedVerifyButton(_ sender: HMShadowButton) {
        HMVerifyCodeAPI.init(phoneNumber: phoneNumber).execute(target: self)
    }
    
}
