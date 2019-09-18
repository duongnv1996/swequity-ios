//
//  HMCountDownVC.swift
//  SwequityVN
//
//  Created by NamNH-D1 on 7/26/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
protocol HMCountDownVCDelegate: NSObject {
    func updateValueRoundEx()
}
class HMCountDownVC: HMBaseVC {

    // MARK: - Outlets
    @IBOutlet weak var countDownLB: UILabel!
    
    // MARK: - Variables
    private var timer: Timer?
    private var endTime: TimeInterval?
    var timeCountDown: Double = 1.0
    
    var sessionId:String?
    var exId:String?
    var listExercise: [HMSetsDetailEntity] = []
    
    weak var delegate:HMCountDownVCDelegate?
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func setupView() {
        super.setupView()
        
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(getRemainTime), userInfo: nil, repeats: true)
        timer?.fire()
    }
    
    @objc private func getRemainTime() {
        timeCountDown = timeCountDown - 0.01
        
        if timeCountDown <= 0 {
            timer?.invalidate()
            timer = nil
            HMUpdatePositionExAPI.init(sessionId: self.sessionId ?? "", exId: self.exId ?? "", numberSets: String(self.listExercise.count)).execute(target: self, success: { (response) in
                switch response.errorId {
                case HMErrorCode.success.rawValue:
                    break
                case HMErrorCode.error.rawValue:
                    UIAlertController.showQuickSystemAlert(message: response.message, cancelButtonTitle: "Đồng ý")
                default:
                    break
                }
                self.dismiss(animated: true, completion: nil)
                self.delegate?.updateValueRoundEx()
            }, failure: { (error) in
                self.dismiss(animated: true, completion: nil)
                self.delegate?.updateValueRoundEx()
            })
        } else {
            DispatchQueue.main.async {
                let remainTime = String(format: "%.2f", self.timeCountDown)
                let countStr = "\(remainTime)s"
                let attributedString = NSMutableAttributedString(string: "\(countStr)", attributes: [
                    .font: UIFont(name: "OpenSans", size: 28.0)!,
                    .foregroundColor: UIColor.white
                    ])
                attributedString.addAttributes([
                    .font: UIFont(name: "OpenSans-Bold", size: 38.0)!,
                    .foregroundColor: UIColor.white
                    ], range: NSRange(location: 0, length: remainTime.count))


                self.countDownLB.attributedText = attributedString
            }
        }
    }
}
