//
//  HMNutritonTargetWeekTargetViewController.swift
//  SwequityVN
//
//  Created by RTC-HN360 on 7/30/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import SwiftyJSON
import Alamofire

class HMNutritonTargetWeekTargetVC: HMBaseVC {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var heightTableView: NSLayoutConstraint!
    
    // MARK: - Variables
    private let disposeBag = DisposeBag()
    let listTarget: BehaviorRelay<[HMTargetDetailEntity]> = BehaviorRelay(value: [])
    
    var targetValue:HMTargetDetailEntity?
    private var foodList:HMFoodListEntity?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
        self.foodList = appDelegate?.foodList
        if self.listTarget.value.count > 0 {
            self.heightTableView.constant = CGFloat(34 * self.listTarget.value.count)
        }
    }

    @IBAction func didTapCloseButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapUpdateButton(_ sender: UIButton) {
        guard let value = self.targetValue?.id else { return  }
        var parameter: Parameters = Parameters()
        parameter = [
            "user_id": HMSharedData.userId!,
            "khoiluong": self.foodList?.target?.khoiluong ?? "0",
            "mucvandong": self.foodList?.target?.mucdovandong ?? "0",
            "tylemo": self.foodList?.target?.tylemo ?? "0",
            "id_target_week": value,
            "id_level": self.foodList?.target?.id_level ?? "1"]
        HMUpdateTargetAPI.init(parameter: parameter).execute(target: self, success: { (response) in
            switch response.errorId {
            case HMErrorCode.success.rawValue:
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: HMConstants.kReloadNutritionGoal), object: nil)
                self.dismiss(animated: true, completion: nil)
                break
            case HMErrorCode.error.rawValue:
                UIAlertController.showQuickSystemAlert(message: response.message, cancelButtonTitle: "Đồng ý")
            default:
                break
            }
        }, failure: { (error) in
            
        })
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Setup views
    override func setupView() {
        super.setupView()
        
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.registerNibCellFor(type: HMNutritonTargetCell.self)
        
        listTarget.bind(to: tableView.rx.items(cellIdentifier: "HMNutritonTargetCell", cellType: HMNutritonTargetCell.self)) { row, model, cell in
            var isSeleted:Bool = false
            if let target = self.targetValue {
                isSeleted = model.id == target.id
            } else {
                isSeleted = false
            }
            cell.setContentWithEntity(target: model, isSelect: isSeleted)
            }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(HMTargetDetailEntity.self).subscribe(onNext: {target in
            self.targetValue = target
        }).disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.tableView.deselectRow(at: indexPath, animated: true)
                self?.tableView.reloadData()
            }).disposed(by: disposeBag)
    }
    
    // MARK: - Management data
//    private func fetchData() {
//        HMNotificationListAPI().execute(target: self, success: {[weak self] (response) in
//            guard let sSelf = self else { return }
//            switch response.errorId {
//            case HMErrorCode.success.rawValue:
//                sSelf.listNotifications.accept(response.listNotifications)
//            case HMErrorCode.error.rawValue:
//                UIAlertController.showQuickSystemAlert(message: response.message, cancelButtonTitle: "Đồng ý")
//            default:
//                break
//            }
//            }, failure: { (error) in
//                UIAlertController.showQuickSystemAlert(message: error.message, cancelButtonTitle: "Đồng ý")
//        })
//    }
    
}
