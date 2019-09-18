//
//  HMMenuVC.swift
//  TimXe
//
//  Created by NamNH-D1 on 5/9/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import SideMenu
import Kingfisher

class HMMenuVC: HMBaseVC {

    // MARK: - Outlets
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var vipLB: UILabel!
    @IBOutlet weak var upgradeAccountButton: UIButton!
    // MARK: - Constants
    
    // MARK: - Variables
    var userInfo:[HMUserInfoRealm] = []
    
    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.isHidden = true
        
        self.userInfo = HMRealmService.instance.load(listOf: HMUserInfoRealm.self, filter: String(format: "userId = '%@'", HMSharedData.userId!))
        if self.userInfo.count > 0 {
            userName.text = userInfo[0].userName
            vipLB.text = (userInfo[0].type == .normal) ? "Thành viên thường" : "Thành viên VIP"
            upgradeAccountButton.isHidden = userInfo[0].type == .vip
            let avatarUrl = URL(string: userInfo[0].avatar ?? "")
            self.avatar.kf.setImage(with: avatarUrl)
        }
        
    }
    
    override func setupView() {
        super.setupView()
    }
    
    // MARK: - Data management
    
    // MARK: - Action
    @IBAction func invokeProfileButton(_ sender: UIButton) {
        HMUpdateProfileVC.push()
    }
    
    @IBAction func invokeHomeButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func invokeDiaryButton(_ sender: UIButton) {
        HMDiaryVC.push()
    }
    
    @IBAction func invokeTrainingProgram(_ sender: UIButton) {
        HMTrainingProgramVC.push(prepare: { (vc) in
            vc.type = HMCalendarType.add
        }, completion: nil)
    }
    
    @IBAction func invokeListExercise(_ sender: UIButton) {
        HMCategoryAPI().execute(target: self, success: { (response) in
            switch response.errorId {
            case HMErrorCode.success.rawValue:
                HMListExVC.push(prepare: { vc in
                    vc.isFavorite = false
                    vc.menuTitles = response.categoryList.compactMap({ return $0.title})
                    vc.menuIds = response.categoryList.compactMap({ return $0.id})
                })
            case HMErrorCode.error.rawValue:
                UIAlertController.showQuickSystemAlert(message: response.message, cancelButtonTitle: "Đồng ý")
            default:
                break
            }
        }, failure: { (error) in
            UIAlertController.showQuickSystemAlert(message: error.message, cancelButtonTitle: "Đồng ý")
        })
        
    }
    
    @IBAction func invokeStatisticalButton(_ sender: UIButton) {
        HMStatisticalVC.push()
    }
    
    @IBAction func invokeNutritionButton(_ sender: UIButton) {
        if self.userInfo[0].type == .vip{
            HMNutritionGoalVC.push()
        } else {
            let upgradePremiumAlertVC = HMUpgradePremiumAlertVC.create()
            let popupVC = HMPopUpViewController(contentController: upgradePremiumAlertVC, position: .bottom(0), popupWidth: HMSystemInfo.screenWidth, popupHeight: HMSystemInfo.screenHeight)
            popupVC.backgroundAlpha = 0.3
            popupVC.cornerRadius = 0
            popupVC.shadowEnabled = false
            let vc = self.presentingViewController
            self.dismiss(animated: true) {
                vc?.present(popupVC, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func invokeFavoriteButton(_ sender: UIButton) {
        HMCategoryAPI().execute(target: self, success: { (response) in
            switch response.errorId {
            case HMErrorCode.success.rawValue:
                HMListExVC.push(prepare: { vc in
                    vc.isFavorite = true
                    vc.menuTitles = response.categoryList.compactMap({ return $0.title})
                    vc.menuIds = response.categoryList.compactMap({ return $0.id})
                })
            case HMErrorCode.error.rawValue:
                UIAlertController.showQuickSystemAlert(message: response.message, cancelButtonTitle: "Đồng ý")
            default:
                break
            }
        }, failure: { (error) in
            UIAlertController.showQuickSystemAlert(message: error.message, cancelButtonTitle: "Đồng ý")
        })
    }
    
    @IBAction func invokeNotificationButton(_ sender: UIButton) {
        HMNotificationVC.push()
    }
    
    @IBAction func invokeUpgradeAccountButton(_ sender: UIButton) {
        dismissToRoot(controller: self, animated: true) { (rootVC) in
            let upgradePremiumAlertVC = HMUpgradePremiumAlertVC.create()
            
            let popupVC = HMPopUpViewController(contentController: upgradePremiumAlertVC, position: .bottom(0), popupWidth: HMSystemInfo.screenWidth, popupHeight: HMSystemInfo.screenHeight)
            popupVC.backgroundAlpha = 0.3
            popupVC.cornerRadius = 0
            popupVC.shadowEnabled = false
            rootVC?.present(popupVC, animated: true, completion: nil)
        }
    }
    @IBAction func invokeLogoutButton(_ sender: UIButton) {
        HMRealmService.instance.write { (realm) in
            realm.delete(realm.objects(HMUserInfoRealm.self))
        }
        dismissToRoot(controller: self, animated: false) { (rootVC) in
            HMSharedData.userId = nil
            
            var window = UIApplication.shared.keyWindow
            let nav = UINavigationController(rootViewController: HMLoginVC.create())
            HMSystemBoots.instance.changeRoot(window: &window, rootController: nav)
        }
        
    }
    
    @IBAction func invokeSupportButton(_ sender: UIButton) {
    }
    
    @IBAction func invokePrivacyButton(_ sender: UIButton) {
        HMPrivacyVC.push()
    }
    
    // MARK: - Private method
}
