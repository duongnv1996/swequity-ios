//
//  HMNotificationDetailVC.swift
//  Develop
//
//  Created by RTC-HN360 on 7/27/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import WebKit

class HMNotificationDetailVC: HMBaseVC {

    // MARK: - Outlets
    @IBOutlet weak var notificationImageView: UIImageView!
    @IBOutlet weak var notificationTitleLabel: UILabel!
    @IBOutlet weak var webContentView: WKWebView!
    
    // MARK: - Variables
    var idNotification: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        titleScreen = "Thông báo"
        self.webContentView.scrollView.isScrollEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    // MARK: - Management data
    private func fetchData() {
        HMNotificationDetailAPI(id: idNotification).execute(target: self, success: { (response) in
        self.notificationTitleLabel.text = response.notificationDetail?.title
        self.webContentView.loadHTMLString(response.notificationDetail?.content ?? "", baseURL: nil)
        }, failure: { (error) in
        
        })
    }
}
