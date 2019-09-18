//
//  HMNutritonTargetActionLevelVC.swift
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

class HMNutritonTargetActionLevelVC: HMBaseVC {
    
    @IBOutlet weak var targetTableView: UITableView!
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
    
    
    @IBAction func didTapUpdateButton(_ sender: UIButton) {
        guard let value = self.targetValue?.id else { return  }
        var parameter: Parameters = Parameters()
        parameter = [
            "user_id": HMSharedData.userId!,
            "khoiluong": self.foodList?.target?.khoiluong ?? "0",
            "mucvandong": self.foodList?.target?.mucdovandong ?? "1",
            "tylemo": self.foodList?.target?.tylemo ?? "0",
            "id_target_week": self.foodList?.target?.id_target_week ?? "1",
            "id_level": value]
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
    
    @IBAction func didTapCancelButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapCloseButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Setup views
    override func setupView() {
        super.setupView()
        
        setupTableView()
    }
    
    private func setupTableView() {
        targetTableView.registerNibCellFor(type: HMNutritonTargetCell.self)
        
        listTarget.bind(to: targetTableView.rx.items(cellIdentifier: "HMNutritonTargetCell", cellType: HMNutritonTargetCell.self)) { row, model, cell in
            var isSeleted:Bool = false
            if let target = self.targetValue {
                isSeleted = model.id == target.id
            }
            cell.setContentWithEntity(target: model, isSelect: isSeleted)
            }.disposed(by: disposeBag)
        
        targetTableView.rx.modelSelected(HMTargetDetailEntity.self).subscribe(onNext: {target in
            self.targetValue = target
        }).disposed(by: disposeBag)
        
        targetTableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.targetTableView.deselectRow(at: indexPath, animated: true)
                self?.targetTableView.reloadData()
            }).disposed(by: disposeBag)
    }
}
