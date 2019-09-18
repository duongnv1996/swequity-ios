//
//  HMStatisticalDataVC.swift
//  SwequityVN
//
//  Created by RTC-HN360 on 7/30/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit

class HMStatisticalDataVC: HMBaseVC {

    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var weightLipitLabel: UILabel!
    @IBOutlet weak var weightLipitPerLabel: UILabel!
    @IBOutlet weak var weightNoLipitLabel: UILabel!
    @IBOutlet weak var weightNoLipitPerLabel: UILabel!
    
    var bodyInfo: HMBodyInfoEntity? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        HMBodyInfoAPI.init().execute(target: self, success: { [weak self] (response) in
            switch response.errorId {
            case HMErrorCode.success.rawValue:
                self?.bodyInfo = response.bodyInfo
                self?.setContent()
                break
            case HMErrorCode.error.rawValue:
                UIAlertController.showQuickSystemAlert(message: response.message, cancelButtonTitle: "Đồng ý")
            default:
                break
            }
        }, failure: { (error) in
            
        })
    }
    
    @IBAction func didTapChangeValueButton(_ sender: UIButton) {
        HMUpdateDataVC.push(prepare: {[weak self] (vc) in
            vc.bodyInfo = self?.bodyInfo
        })
    }
    
    
    @IBAction func invokeBodyChartButton(_ sender: UIButton) {
        HMBodyChartsVC.push()
    }
    
    //MARK - Private methods
    
    func setContent() {
        self.weightLabel.text = "\(self.bodyInfo?.khoiluong ?? "0")kg"
        self.weightLipitLabel.text = "\(self.bodyInfo?.khoiluongmo  ?? "0")kg"
        self.weightLipitPerLabel.text = "\(self.bodyInfo?.phantrammo  ?? "0")%"
        self.weightNoLipitLabel.text = "\(self.bodyInfo?.khoiluongnac  ?? "0")kg"
        self.weightNoLipitPerLabel.text = "\(self.bodyInfo?.phantramnac  ?? "0")%"
    }
}
