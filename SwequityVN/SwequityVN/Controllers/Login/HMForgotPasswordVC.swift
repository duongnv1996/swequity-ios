//
//  HMForgotPasswordVC.swift
//  Develop
//
//  Created by RTC-HN360 on 7/25/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit

class HMForgotPasswordVC: HMBaseVC {

    @IBOutlet weak var phoneNumberTf: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func didTappedPrivacyButton(_ sender: UIButton) {
        HMPrivacyAPI.init().execute(target: self, success: { (response) in
            switch response.errorId {
            case HMErrorCode.success.rawValue:
                HMPrivacyVC.push()
                break
            case HMErrorCode.error.rawValue:
                UIAlertController.showQuickSystemAlert(message: response.message, cancelButtonTitle: "Đồng ý")
            default:
                break
            }
        }, failure: { (error) in
            
        })
    }
    
    @IBAction func didTappedTermButton(_ sender: UIButton) {
        HMTermAPI.init().execute(target: self, success: { (response) in
            switch response.errorId {
            case HMErrorCode.success.rawValue:
                HMTermVC.push()
                break
            case HMErrorCode.error.rawValue:
                UIAlertController.showQuickSystemAlert(message: response.message, cancelButtonTitle: "Đồng ý")
            default:
                break
            }
        }, failure: { (error) in
            
        })
    }
    
    @IBAction func didTapResenPassword(_ sender: UIButton) {
        guard let phoneNumber = phoneNumberTf.text, !phoneNumberTf.text!.isEmpty else { return }
        HMForgetPasswordAPI.init(phone: phoneNumber).execute(target: self)
    }
    
}
