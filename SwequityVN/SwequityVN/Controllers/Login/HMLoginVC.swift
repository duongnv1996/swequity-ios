//
//  HMLoginVC.swift
//  ProjectBase
//
//  Created by Nguyễn Nam on 4/8/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit

class HMLoginVC: HMBaseVC {
    
    // MARK: - Outlets
    
    // MARK: - Variables
    private var facebookLogin: HMFacebookLoginServices?
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationController?.navigationBar.isHidden = true
        
        facebookLogin = HMFacebookLoginServices(target: self)
    }

    // MARK: - Actions
    @IBAction func invokeFacebookLogin(_ sender: UIButton) {
        facebookLogin?.doLogin()
    }
    
    @IBAction func invokeGoogleLogin(_ sender: UIButton) {
//        let googleLogin = HMGoogleLoginServices(target: self)
//        googleLogin.doLogin()
    }
    
}

extension HMLoginVC: HMLoginServicesDelegate {
    func didLogin(profile: HMUserProfileEntity?) {
        // Do somethings after login by Facebook or Google
        guard let profile = profile else {
            return
        }
        print("Did login + type: \(profile.type)")
        
        switch profile.type {
        case .facebook:
            HMFacebookLoginAPI(email: profile.email, fbid: profile.uid, name: profile.name).execute(target: self, success: { (response) in
                var window = UIApplication.shared.keyWindow
                let rootVC = UINavigationController(rootViewController: HMHomeVC.create())
                HMSystemBoots.instance.changeRoot(window: &window, rootController: rootVC)
            }) { (error) in
                
            }
        default:
            break
        }
    }
}
