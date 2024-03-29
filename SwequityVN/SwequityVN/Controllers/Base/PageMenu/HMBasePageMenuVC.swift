//
//  HMBasePageMenuVC.swift
//  SwequityVN
//
//  Created by Nguyễn Nam on 7/27/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import Parchment

class HMBasePageMenuVC: HMBaseVC, PagingViewControllerDelegate, PagingViewControllerDataSource {

    var viewControllers: [UIViewController] = []
    var menuTitles: [String] = []
    var iconTitles: [String] = []
    
    let pagingViewController = PagingViewController<HMPageItem>()
    
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pagingViewController.menuItemSource = .class(type: HMPageItemCell.self)
        pagingViewController.menuItemSize = .sizeToFit(minWidth: 150.0, height: 60.0)
        pagingViewController.dataSource = self
        pagingViewController.delegate = self
        pagingViewController.indicatorColor = .clear
        pagingViewController.menuBackgroundColor = UIColor(hex: 0xF7F7F7)
        pagingViewController.menuInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        pagingViewController.borderColor = .clear
        
        addChild(pagingViewController)
        containerView.addSubview(pagingViewController.view)
        pagingViewController.view.fixInView(containerView)
        pagingViewController.didMove(toParent: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        pagingViewController.reloadMenu()
    }
    func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, viewControllerForIndex index: Int) -> UIViewController {
        return viewControllers[index]
    }
    
    func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, pagingItemForIndex index: Int) -> T {
        if iconTitles.count > 0 {
            return HMPageItem(title: menuTitles[index], icon: iconTitles[index], index: index) as! T
        } else {
            return HMPageItem(title: menuTitles[index], index: index) as! T
        }
    }
    
    func numberOfViewControllers<T>(in: PagingViewController<T>) -> Int {
        return menuTitles.count
    }
    
    func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, willScrollToItem pagingItem: T, startingViewController: UIViewController, destinationViewController: UIViewController) {
        
    }
    
    func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, didScrollToItem pagingItem: T, startingViewController: UIViewController?, destinationViewController: UIViewController, transitionSuccessful: Bool) where T : PagingItem, T : Comparable, T : Hashable {
        
    }

}
