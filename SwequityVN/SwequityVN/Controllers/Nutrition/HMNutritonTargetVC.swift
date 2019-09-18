//
//  HMNutritonTargetVC.swift
//  SwequityVN
//
//  Created by RTC-HN360 on 7/29/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class HMNutritonTargetVC: HMBaseVC {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var imageTarget: UIImageView!
    @IBOutlet weak var valueLabel: HMInsetTextField!
    
    var type: HMTargetFillType?
    var value: String?
    private var foodList:HMFoodListEntity?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = type == HMTargetFillType.weight ? "SỐ CÂN HIỆN TẠI" : "TỈ LỆ MỠ CƠ THỂ"
        contentLabel.text = type == HMTargetFillType.weight ? "Thiết lập mục tiêu cân nặng tuần để biết chính xác cân nặng của bạn một cách cụ thể" : "Vui lòng nhập tỉ lệ mỡ trên cơ thể của bạn để chúng tôi tính toán mức dinh dưỡng hợp lý."
        unitLabel.text = type == HMTargetFillType.weight ? "KG" : "%"
        let imageName: String = type == HMTargetFillType.weight ? "icon_weight" : "icon_fat"
        imageTarget.image = UIImage(named: imageName)
//        valueLabel.text = self.value
        
        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
        self.foodList = appDelegate?.foodList
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func didTapUpdateButton(_ sender: UIButton) {
        guard let value = self.valueLabel.text else { return  }
        var parameter: Parameters = Parameters()
        parameter = [
            "user_id": HMSharedData.userId!,
            "khoiluong": type == HMTargetFillType.weight ? value : self.foodList?.target?.khoiluong ?? "",
            "mucvandong": self.foodList?.target?.mucdovandong ?? "1",
            "tylemo": type == HMTargetFillType.weight ? self.foodList?.target?.tylemo ?? "0" : value,
            "id_target_week": self.foodList?.target?.id_target_week ?? "1",
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
    }
    
    @IBAction func didTapCancelButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
