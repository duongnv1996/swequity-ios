//
//  HMStatisticalSessionVC.swift
//  SwequityVN
//
//  Created by RTC-HN360 on 7/31/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import FacebookShare

class HMStatisticalSessionVC: HMBaseVC {

    @IBOutlet weak var timeExerciseLabel: UILabel!
    @IBOutlet weak var numberExerciseLabel: UILabel!
    @IBOutlet weak var totalWeightLabel: UILabel!
    @IBOutlet weak var relaxTimeLabel: UILabel!
    
    var sessionId:String?
    var programId:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleScreen = "Thống kê buổi tập"
        HMTotalWeightSesstionAPI.init(sessionId: self.sessionId ?? "").execute(target: self, success: { (response) in
            self.totalWeightLabel.text = response.totalWeight
        }, failure: { (error) in
            
        })
        
        let timeEndEx = Date()
        let hour = Date.hourBetween(start: HMSharedData.timeStartEx ?? Date(), end: timeEndEx)
        let minute = Date.minuteBetween(start: HMSharedData.timeStartEx ?? Date(), end: timeEndEx) - hour * 60
        let second = Date.secondBetween(start: HMSharedData.timeStartEx ?? Date(), end: timeEndEx) - minute * 60
        self.timeExerciseLabel.text = "\(hour):\(minute):\(second)"
        
        self.numberExerciseLabel.text = HMSharedData.numberExercise
        self.relaxTimeLabel.text = HMSharedData.relaxTime
        
    }
    
    @IBAction func didTapShareFbButton(_ sender: UIButton) {
        let content:LinkShareContent = LinkShareContent.init(url: URL.init(string: "https://developers.facebook.com") ?? URL.init(fileURLWithPath: "https://developers.facebook.com"), quote: "Share This Content")
        
        let shareDialog = ShareDialog(content: content)
        shareDialog.mode = .native
        shareDialog.failsOnInvalidData = true
        shareDialog.completion = { result in
            // Handle share results
        }
        do
        {
            try shareDialog.show()
        }
        catch
        {
            print("Exception")
            
        }
    }
    
    @IBAction func didTapContinueButton(_ sender: UIButton) {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: currentDate)
        
        if let viewControllerList = self.navigationController?.viewControllers {
            for vc:UIViewController in viewControllerList {
                if vc.isKind(of: HMExerciseProgramVC.self) {
                    HMExerciseInDateAPI.init(date: dateString).execute(target: self, success: { (response) in
                        self.numberExerciseLabel.text = String(response.exList.count)
                    }, failure: { (error) in
                        
                    })
                    self.pop(to: vc)
                }
            }
        }
    }
    
    @IBAction func didTapShowHistoryButton(_ sender: UIButton) {
        if let viewControllerList = self.navigationController?.viewControllers {
            for vc:UIViewController in viewControllerList {
                if vc.isKind(of: HMHomeVC.self) {
                    HMListProgramAPI().execute(target: self, success: {[weak self] (response) in
                        guard let sSelf = self else { return }
                        switch response.errorId {
                        case HMErrorCode.success.rawValue:
                            sSelf.pop(to: vc)
                            HMDiaryVC.push()
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
        }
    }
    
}
