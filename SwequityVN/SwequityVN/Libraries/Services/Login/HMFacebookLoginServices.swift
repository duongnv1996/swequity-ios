//
//  HMFacebookLoginServices.swift
//  ProjectBase
//
//  Created by NamNH-D1 on 4/9/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore

class HMFacebookLoginServices: NSObject, HMLoginServices {
    
    // MARK: - Variables
    weak var delegate: HMLoginServicesDelegate?
    private let parameters = ["fields":"id,email,name"]
    private let graphPath = "me"
    
    // MARK:- Init
    required init(target viewController: UIViewController & HMLoginServicesDelegate) {
//        super.init()
        delegate = viewController
    }
    
    // MARK: - Action
    func doLogin() {
        if let accessToken = AccessToken.current {
            print("Signed in")
            getDataFB(accessToken: accessToken)
            return
        }
        
        let loginManager = LoginManager(loginBehavior: .browser, defaultAudience: .friends)
        
        loginManager.logIn(readPermissions: [.email], viewController: delegate as? UIViewController) { [weak self] (result) in
            guard let sSelf = self else {
                return
            }
            switch result {
            case .success(_,_,let token):
                print(".success")
                sSelf.getDataFB(accessToken: token)
            case .cancelled, .failed(_):
                print(".cancelled, .failed")
                break
            }
        }
    }
    
    func didLogin() {
        
    }
    
    // MARK: - Private method
    private func getDataFB(accessToken: AccessToken) {
        GraphRequest(graphPath: graphPath, parameters: parameters, accessToken: accessToken, httpMethod: .GET, apiVersion: .defaultVersion).start { [weak self] (httpResponse, result) in
            guard let sSelf = self else { return }
            switch result {
            case .success(let response):
                if let dict = response.dictionaryValue, let id = dict["id"] as? String {
                    var userProfile = HMUserProfileEntity()
                    userProfile.uid = id
                    userProfile.name = dict["name"] as? String ?? ""
                    userProfile.email = dict["email"] as? String ?? ""
                    userProfile.type = LoginType.facebook
                    sSelf.delegate?.didLogin(profile: userProfile)
                } else {
                    sSelf.delegate?.didLogin(profile: nil)
                }
            case .failed(let error):
                print(error)
                sSelf.delegate?.didLogin(profile: nil)
            }
        }
    }
}
