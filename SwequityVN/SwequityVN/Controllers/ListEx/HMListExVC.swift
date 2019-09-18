//
//  HMListExVC.swift
//  SwequityVN
//
//  Created by Nguyễn Nam on 7/27/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import Parchment

class HMListExVC: HMBasePageMenuVC {

    var menuIds: [String?] = []
    var isFavorite: Bool = false
    var type:HMListType = .list
    var sessionId: String?
    
    override func viewDidLoad() {
        iconTitles = Array(repeating: "icon_pics", count: menuTitles.count)
        if isFavorite {
            viewControllers = menuIds.compactMap({
                let vc = HMExerciseFavoriteVC.create()
                vc.categoryId = $0
                vc.type = self.type
                vc.sessionId = self.sessionId
                return vc
            })
        } else {
            menuTitles.insert("Yêu thích", at: 0)
            iconTitles.insert("icon_pics", at: 0)
            menuIds.insert(nil, at: 0)
            viewControllers = menuIds.compactMap({
                let vc = HMExerciseCateVC.create()
                vc.categoryId = $0
                vc.type = self.type
                vc.sessionId = self.sessionId
                return vc
            })
        }
        
        super.viewDidLoad()
        
        if !isFavorite && menuTitles.count > 1 {
            pagingViewController.select(index: 1)
        }
    }
    
    override func setupView() {
        super.setupView()
        titleScreen = isFavorite ? "Bài tập yêu thích" : "Danh sách bài tập"
    }
}
