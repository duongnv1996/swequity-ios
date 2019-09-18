//
//  HMNotificationVC.swift
//  SwequityVN
//
//  Created by RTC-HN360 on 7/28/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class HMNotificationVC: HMBaseVC {

    @IBOutlet weak var notificationTableView: UITableView!
    
    // MARK: - Variables
    private let disposeBag = DisposeBag()
    private let listNotifications: BehaviorRelay<[HMNotificationDetailEntity]> = BehaviorRelay(value: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchData()
    }
    
    // MARK: - Setup views
    override func setupView() {
        super.setupView()
        
        titleScreen = "Thông báo"
        setupTableView()
    }
    
    private func setupTableView() {
        notificationTableView.registerNibCellFor(type: HMNotificationTableViewCell.self)
        
        listNotifications.bind(to: notificationTableView.rx.items(cellIdentifier: "HMNotificationTableViewCell", cellType: HMNotificationTableViewCell.self)) { row, model, cell in
            cell.setContentWithEntity(notificationEntity: model)
            }.disposed(by: disposeBag)
        
        notificationTableView.rx.modelSelected(HMNotificationDetailEntity.self).subscribe(onNext: {notification in
            HMNotificationDetailVC.push(prepare: { vc in
                vc.idNotification = notification.id
            })
        }).disposed(by: disposeBag)
        
        notificationTableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.notificationTableView.deselectRow(at: indexPath, animated: true)
            }).disposed(by: disposeBag)
    }
    
    // MARK: - Management data
    private func fetchData() {
        HMNotificationListAPI().execute(target: self, success: {[weak self] (response) in
            guard let sSelf = self else { return }
            switch response.errorId {
            case HMErrorCode.success.rawValue:
                sSelf.listNotifications.accept(response.listNotifications)
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
