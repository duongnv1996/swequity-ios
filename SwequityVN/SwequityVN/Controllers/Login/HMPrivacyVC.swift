//
//  HMPrivacyVC.swift
//  SwequityVN
//
//  Created by RTC-HN360 on 8/7/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import WebKit

class HMPrivacyVC: HMBaseVC {

    @IBOutlet weak var privacyContent: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.privacyContent.scrollView.isScrollEnabled = true
        
        HMPrivacyAPI.init().execute(target: self, success: {[weak self] (response) in
            switch response.errorId {
            case HMErrorCode.success.rawValue:
                self?.privacyContent.loadHTMLString(response.privacy?.content ?? "", baseURL: nil)
                break
            case HMErrorCode.error.rawValue:
                UIAlertController.showQuickSystemAlert(message: response.message, cancelButtonTitle: "Đồng ý")
            default:
                break
            }
        }, failure: {(error) in
            
        })
    }

}
