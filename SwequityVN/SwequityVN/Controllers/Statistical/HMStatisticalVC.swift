//
//  HMStatisticalVC.swift
//  SwequityVN
//
//  Created by NamNH-D1 on 8/5/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import Parchment

enum StatisticalMenuItem: Int {
    case data = 0
    case image = 1
    
    static let iconTitles = ["icon_strong","icon_body"]
    static let menuTitles = ["Số liệu cơ thể","Nhật ký hình ảnh"]
    
    func getMenuTitle() -> String {
        return StatisticalMenuItem.menuTitles[self.rawValue]
    }
}
class HMStatisticalVC: HMBasePageMenuVC {

    var menuType: StatisticalMenuItem = .data
    var imageMenuType: HMImageType = .front
    let historyImageVC = HMHistoryImageVC.create()
    
    override func viewDidLoad() {
        iconTitles = StatisticalMenuItem.iconTitles
        menuTitles = StatisticalMenuItem.menuTitles
        
        historyImageVC.didSelectMenu = { menuType in
            self.imageMenuType = menuType
        }
        
        viewControllers = [HMStatisticalDataVC.create(), historyImageVC]
        super.viewDidLoad()
        pagingViewController.select(index: menuType.rawValue)
        
        if self.menuType == StatisticalMenuItem.image {
            navigationItem.rightBarButtonItems = rightBarButton()
        }
    }
    
    override func setupView() {
        super.setupView()
        
        titleScreen = "Thống kê số liệu"
    }
    
    override func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, willScrollToItem pagingItem: T, startingViewController: UIViewController, destinationViewController: UIViewController) {
        if destinationViewController.isKind(of: HMHistoryImageVC.self) {
            navigationItem.rightBarButtonItems = rightBarButton()
        } else {
            navigationItem.rightBarButtonItems = []
        }
        
    }
    
    // MARK: - Private methods
    private func rightBarButton() -> [UIBarButtonItem] {
        let listView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        let listButton = UIButton(frame: listView.frame)
        listButton.addTarget(self, action: #selector(invokeCameraButton(_:)), for: .touchUpInside)
        
        let listImageView = UIImageView(frame: CGRect(x: 0, y: 10, width: 20, height: 20))
        listImageView.image = UIImage(named: "icon_camera_1")
        listView.addSubview(listImageView)
        listView.addSubview(listButton)
        
        let listItem = UIBarButtonItem.init(customView: listView)
        
        return [listItem]
    }
    
    @objc private func invokeCameraButton(_ sender: Any) {
        let tutorial = HMTutorialImageVC.create()
        
        tutorial.didPickedImage = {[weak self] imageData in
            guard let sSelf = self else { return }
            
            sSelf.dismiss(animated: true, completion: {
                let pickupSideVC = HMPickupSideVC.create()
                pickupSideVC.didUpdateImage = { imageType in
                    sSelf.fetchUpdateImage(imageData: imageData, imageType: imageType)
                    sSelf.dismiss(animated: true, completion: nil)
                }
                let popupPickupSideVC = HMPopUpViewController(contentController: pickupSideVC, position: .bottom(0), popupWidth: HMSystemInfo.screenWidth, popupHeight: HMSystemInfo.screenHeight)
                popupPickupSideVC.shadowEnabled = false
                sSelf.present(popupPickupSideVC, animated: true, completion: nil)
            })
            
        }
        
        let popupVC = HMPopUpViewController(contentController: tutorial, position: .bottom(0), popupWidth: HMSystemInfo.screenWidth, popupHeight: HMSystemInfo.screenHeight)
        popupVC.shadowEnabled = false
        present(popupVC, animated: true, completion: nil)
    }
    
    private func fetchUpdateImage(imageData: Data, imageType: HMImageType) {
        HMUpdateBodyImageAPI(image: imageData, type: imageType).execute(target: self, success: {[weak self] (response) in
            guard let sSelf = self else { return }
            switch response.errorId {
            case HMErrorCode.success.rawValue:
                sSelf.historyImageVC.reloadData()
            case HMErrorCode.error.rawValue:
                UIAlertController.showQuickSystemAlert(message: response.message, cancelButtonTitle: "Đồng ý")
            default:
                break
            }
            }, failure: { (error) in
                UIAlertController.showQuickSystemAlert(message: error.message, cancelButtonTitle: "Đồng ý")
        })
    }
}


