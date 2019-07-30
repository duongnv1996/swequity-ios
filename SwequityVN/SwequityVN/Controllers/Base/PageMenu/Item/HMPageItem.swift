//
//  HMPageItem.swift
//  SwequityVN
//
//  Created by Nguyễn Nam on 7/27/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import Parchment

struct HMPageItem: PagingItem, Hashable, Comparable {
    
    let icon: String
    let title: String
    let index: Int
    let image: UIImage?
    
    init(title: String, icon: String, index: Int) {
        self.title = title
        self.icon = icon
        self.index = index
        self.image = UIImage(named: icon)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(icon)
    }
    
    static func <(lhs: HMPageItem, rhs: HMPageItem) -> Bool {
        return lhs.index < rhs.index
    }
    
    static func ==(lhs: HMPageItem, rhs: HMPageItem) -> Bool {
        return (
            lhs.index == rhs.index &&
                lhs.title == rhs.title &&
                lhs.icon == rhs.icon
        )
    }
}
