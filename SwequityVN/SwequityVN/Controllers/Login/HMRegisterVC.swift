//
//  HMRegisterVC.swift
//  Develop
//
//  Created by RTC-HN360 on 7/25/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit

class HMRegisterVC: HMBaseVC {

    @IBOutlet weak var phoneNumberTf: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func didTappedRegisterButton(_ sender: HMShadowButton) {
        guard let phoneNumber = phoneNumberTf.text, !phoneNumber.isEmpty else { return }
        HMVerifyCodeAPI.init(phoneNumber: phoneNumberTf.text!).execute(target: self)
    }
    
}
