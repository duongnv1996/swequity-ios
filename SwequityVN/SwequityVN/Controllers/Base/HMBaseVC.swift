//
//  HMBaseVC.swift
//  ProjectBase
//
//  Created by Nguyễn Nam on 4/8/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import SideMenu

class HMBaseVC: UIViewController {

    var titleScreen: String? {
        didSet {
            navigationItem.title = titleScreen
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
    }
    
    func setupView() {
        baseConfig()
    }
    
    // MARK: - Private method
    private func baseConfig() {
        addBaseBackground()
        
        if #available(iOS 11, *) {}
        else {
            edgesForExtendedLayout = []
        }
        
        if(self.isKind(of: HMHomeVC.self)) {
            navigationItem.titleView = UIImageView(image: UIImage(named: "logo_SWEATF"))
            addMenuNavigationBarbutton()
        } else {
            addBackNavigationBarbutton()
        }
    }
    
    private func addBaseBackground() {
        
    }
    
    private func hideTabBar() {
        
    }
    
    private func hideNaviBar() {
        
    }
    
    private func addMenuNavigationBarbutton() {
        let menuView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        let menuButton = UIButton(frame: menuView.frame)
        menuButton.addTarget(self, action: #selector(invokeMenuButton(_:)), for: .touchUpInside)
        
        let menuImageView = UIImageView(frame: CGRect(x: 0, y: 15, width: 20, height: 15))
        menuImageView.image = UIImage(named: "icon_menu")
        menuView.addSubview(menuImageView)
        menuView.addSubview(menuButton)
        
        let menuItem = UIBarButtonItem.init(customView: menuView)
        
        navigationItem.leftBarButtonItems = [menuItem]
    }
    
    private func addBackNavigationBarbutton() {
        let backView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        let backButton = UIButton(frame: backView.frame)
        backButton.addTarget(self, action: #selector(invokeBackButton(_:)), for: .touchUpInside)
        
        let backImageView = UIImageView(frame: CGRect(x: 0, y: 10, width: 20, height: 20))
        backImageView.image = UIImage(named: "icon_back")
        backView.addSubview(backImageView)
        backView.addSubview(backButton)
        
        let backItem = UIBarButtonItem.init(customView: backView)
        
        navigationItem.leftBarButtonItems = [backItem]
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    // MARK: - Action
    @objc private func invokeMenuButton(_ sender: Any) {
        present(SideMenuManager.default.leftMenuNavigationController!, animated: true, completion: nil)
    }
    
    @objc private func invokeBackButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
