//
//  HMCountDownVC.swift
//  SwequityVN
//
//  Created by NamNH-D1 on 7/26/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit

class HMCountDownVC: HMBaseVC {

    // MARK: - Outlets
    @IBOutlet weak var countDownLB: UILabel!
    
    // MARK: - Variables
    private var timer: Timer?
    private var endTime: TimeInterval?
    var timeCountDown: Double = 10.00
    
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
        print(String(format: "%02.2f", timeCountDown))
        
        if timeCountDown <= 0 {
            timer?.invalidate()
            timer = nil
            dismiss(animated: true, completion: nil)
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
