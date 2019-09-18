//
//  HMGoogleLoginServices.swift
//  ProjectBase
//
//  Created by NamNH-D1 on 4/9/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import GoogleSignIn

class HMGoogleLoginServices: NSObject, HMLoginServices {
    
    // MARK: - Variables
    weak var delegate: HMLoginServicesDelegate?
    private let clientID = "585025639656-c9rf4sbb31d9ivln3tansinhrngkl2s5.apps.googleusercontent.com"
    private let scopes = ["https://www.googleapis.com/auth/userinfo.profile",
                          "https://www.googleapis.com/auth/userinfo.email"]
    
    // MARK:- Init
    required init(target viewController: UIViewController & HMLoginServicesDelegate) {
        super.init()
        GIDSignIn.sharedInstance().uiDelegate = viewController as? GIDSignInUIDelegate
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().clientID = clientID
        GIDSignIn.sharedInstance().scopes = scopes
        
        delegate = viewController
    }
    
    // MARK: - Action
    func doLogin() {
        GIDSignIn.sharedInstance()?.signIn()
    }
}

// MARK: - GIDSignInDelegate
extension HMGoogleLoginServices: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            var userProfile = HMUserProfileEntity()
            userProfile.uid = user.userID
            userProfile.name = user.profile.name
            userProfile.email = user.profile.email
            userProfile.type = LoginType.google

            delegate?.didLogin(profile: userProfile)
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
    }
}
