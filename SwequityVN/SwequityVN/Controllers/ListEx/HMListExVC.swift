//
//  HMListExVC.swift
//  SwequityVN
//
//  Created by Nguyễn Nam on 7/27/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit

class HMListExVC: HMBasePageMenuVC {

    override func viewDidLoad() {
        viewControllers = [HMDiaryVC.create(), HMDiaryVC.create(), HMDiaryVC.create()]
        menuTitles = ["Toàn thân", "Tập bụng", "Tập chân"]
        iconTitles = ["icon_analysis", "icon_analysis", "icon_analysis"]
        super.viewDidLoad()

    }
    
    override func setupView() {
        super.setupView()
        
        titleScreen = "Bài tập yêu thích"
    }

}
