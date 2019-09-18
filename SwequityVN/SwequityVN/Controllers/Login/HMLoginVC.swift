//
//  HMLoginVC.swift
//  ProjectBase
//
//  Created by Nguyễn Nam on 4/8/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import GoogleSignIn

class HMLoginVC: HMBaseVC {
    
    // MARK: - Outlets
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    // MARK: - Variables
    private var facebookLogin: HMFacebookLoginServices?
    private var googleLogin: HMGoogleLoginServices?
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()

        facebookLogin = HMFacebookLoginServices(target: self)
        googleLogin = HMGoogleLoginServices(target: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }

    // MARK: - Actions
    @IBAction func invokeFacebookLogin(_ sender: UIButton) {
        facebookLogin?.doLogin()
    }
    
    @IBAction func invokeGoogleLogin(_ sender: HMShadowButton) {
        googleLogin?.doLogin()
    }
    
    @IBAction func invokeLoginByUserName(_ sender: UIButton) {
        guard let userName = userNameTF.text,
            let password = passwordTF.text else {
                UIAlertController.showQuickSystemAlert(message: "Nhập đầy đủ thông tin !", cancelButtonTitle: "Đồng ý")
                return
        }
        HMLoginAPI(username: userName, password: password).execute(target: self, success: {[weak self] (response) in
            switch response.errorId {
            case HMErrorCode.success.rawValue:
                self?.didLoginSwequity()
            case HMErrorCode.error.rawValue:
                UIAlertController.showQuickSystemAlert(message: response.message, cancelButtonTitle: "Đồng ý")
            default:
                break
            }
        }, failure: { (error) in
            UIAlertController.showQuickSystemAlert(message: error.message, cancelButtonTitle: "Đồng ý")
        })
    }
    
    @IBAction func invokeRegisterButton(_ sender: UIButton) {
        HMRegisterVC.push()
    }
    
    @IBAction func invokeForgetPassword(_ sender: UIButton) {
        HMForgotPasswordVC.push()
    }
    
    // MARK: - Private methods
    private func didLoginSwequity() {
        var window = UIApplication.shared.keyWindow
        let rootVC = UINavigationController(rootViewController: HMHomeVC.create())
        HMSystemBoots.instance.changeRoot(window: &window, rootController: rootVC)
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
            HMFacebookLoginAPI(email: profile.email, fbid: profile.uid, name: profile.name).execute(target: self, success: {[weak self] (response) in
                switch response.errorId {
                case HMErrorCode.success.rawValue:
                    self?.didLoginSwequity()
                case HMErrorCode.error.rawValue:
                UIAlertController.showQuickSystemAlert(message: response.message, cancelButtonTitle: "Đồng ý")
                default:
                break
            }
        }, failure: { (error) in
            UIAlertController.showQuickSystemAlert(message: error.message, cancelButtonTitle: "Đồng ý")
        })
        case .google:
            HMGoogleLoginAPI(email: profile.email, ggid: profile.uid, name: profile.name).execute(target: self, success: {[weak self] (response) in
                switch response.errorId {
                case HMErrorCode.success.rawValue:
                    self?.didLoginSwequity()
                case HMErrorCode.error.rawValue:
                    UIAlertController.showQuickSystemAlert(message: response.message, cancelButtonTitle: "Đồng ý")
                default:
                    break
                }
            }, failure: { (error) in
                UIAlertController.showQuickSystemAlert(message: error.message, cancelButtonTitle: "Đồng ý")
            })
        default:
            break
        }
    }
}

// MARK: - GIDSignInUIDelegate
extension HMLoginVC: GIDSignInUIDelegate {
    private func signInWillDispatch(signIn: GIDSignIn!, error: NSError!) {
        
    }
    
    // Present a view that prompts the user to sign in with Google
    private func signIn(signIn: GIDSignIn!,
                        presentViewController viewController: UIViewController!) {
    }
    
    // Dismiss the "Sign in with Google" view
    private func signIn(signIn: GIDSignIn!,
                        dismissViewController viewController: UIViewController!) {
    }
}
