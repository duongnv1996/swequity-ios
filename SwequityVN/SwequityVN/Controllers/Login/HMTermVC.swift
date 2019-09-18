//
//  HMTermVC.swift
//  SwequityVN
//
//  Created by RTC-HN360 on 8/7/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import WebKit

class HMTermVC: HMBaseVC {

    @IBOutlet weak var termContent: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.termContent.scrollView.isScrollEnabled = true
        
        HMTermAPI.init().execute(target: self, success: { [weak self](response) in
            switch response.errorId {
            case HMErrorCode.success.rawValue:
                self?.termContent.loadHTMLString(response.term?.content ?? "", baseURL: nil)
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
