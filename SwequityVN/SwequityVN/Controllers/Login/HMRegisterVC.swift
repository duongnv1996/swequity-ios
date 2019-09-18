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
        guard let phoneNumber = phoneNumberTf.text, phoneNumber.isPhoneNumber else {
            UIAlertController.showQuickSystemAlert(message: "Số điện thoại không đúng !", cancelButtonTitle: "Đồng ý")
            return }
        
        HMVerifyCodeAPI(phoneNumber: phoneNumber).execute(target: self, success: { (response) in
            switch response.errorId {
            case HMErrorCode.success.rawValue:
                HMVerifyVC.push(prepare: { vc in
                    vc.phoneNumber = phoneNumber
                    vc.verifyCode = "\(response.verifyCode)"
                })
            case HMErrorCode.error.rawValue:
                UIAlertController.showQuickSystemAlert(message: response.message, cancelButtonTitle: "Đồng ý")
            default:
                break
            }
        }, failure: { (error) in
            UIAlertController.showQuickSystemAlert(message: error.message, cancelButtonTitle: "Đồng ý")
        })
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
    
}
