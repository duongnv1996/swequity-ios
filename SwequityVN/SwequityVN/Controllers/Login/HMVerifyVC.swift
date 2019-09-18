//
//  HMVerifyVC.swift
//  Develop
//
//  Created by RTC-HN360 on 7/25/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit

class HMVerifyVC: HMBaseVC {

    // MARK: - Outlets
    @IBOutlet weak var welcomeLB: UILabel!
    @IBOutlet weak var verifyCodeView: SwiftyCodeView!
    @IBOutlet weak var resendButton: UIButton!
    @IBOutlet weak var countdownLB: UILabel!
    
    // MARK: - Variables
    var phoneNumber: String = ""
    var verifyCode: String!
    private var inputCode: String?
    private var examTimer = Timer()
    private var endTime = Date()
    private var remainTime = DateComponents()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startCountDown()
    }
    
    override func setupView() {
        super.setupView()
        verifyCodeView.delegate = self
        welcomeLB.text = "Mã xác thực vừa đuợc gửi đến số điện thoại \(phoneNumber). Vui lòng nhập mã."
    }
    
    @IBAction func didTappedVerifyButton(_ sender: HMShadowButton) {
        if inputCode == verifyCode {
            HMRegisterAPI(phone: phoneNumber, password: verifyCode).execute(target: self, success: { (response) in
                print(response)
                switch response.errorId {
                case HMErrorCode.success.rawValue:
                    HMUpdateProfileVC.push(prepare: { vc in
                        vc.isRegister = true
                    })
                case HMErrorCode.error.rawValue:
                    UIAlertController.showQuickSystemAlert(message: response.message, cancelButtonTitle: "Đồng ý")
                default:
                    break
                }
            }, failure: { (error) in
                UIAlertController.showQuickSystemAlert(message: error.message, cancelButtonTitle: "Đồng ý")
            })
        } else {
            UIAlertController.showQuickSystemAlert(message: "Mã không đúng !", cancelButtonTitle: "Đồng ý")
        }
    }
    
    @IBAction func invokeResendButton(_ sender: UIButton) {
        HMVerifyCodeAPI(phoneNumber: phoneNumber).execute(target: self)
        startCountDown()
    }
    
    // MARK: - Private method
    private func startCountDown() {
        countdownLB.isHidden = false
        let currentTime = Date()
        endTime = Calendar.current.date(byAdding: .second, value: 60, to: currentTime)!
        examTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(getRemainTime), userInfo: nil, repeats: true)
        examTimer.fire()
    }
    
    @objc private func getRemainTime() {
        remainTime = Calendar.current.dateComponents([.second], from: Date(), to: endTime)
        if let remain = remainTime.second {
            if remain <= 0 {
                DispatchQueue.main.async {
                    self.countdownLB.isHidden = true
                    self.resendButton.isHidden = false
                    self.stopCountDown()
                }
            } else {
                DispatchQueue.main.async {
                    self.countdownLB.isHidden = false
                    
                    let countStr = "\(self.remainTime.second ?? 60)s"
                    let attributedString = NSMutableAttributedString(string: "Gửi lại sau \(countStr)", attributes: [
                        .font: UIFont(name: "OpenSans-Bold", size: 18.0)!,
                        .foregroundColor: UIColor.sunYellow
                        ])
                    attributedString.addAttributes([
                        .font: UIFont(name: "OpenSans", size: 18.0)!,
                        .foregroundColor: UIColor.white
                        ], range: NSRange(location: 0, length: 12))
                    
                    
                    self.countdownLB.attributedText = attributedString
                    self.resendButton.isHidden = true
                }
            }
        }
    }
    
    private func stopCountDown() {
        HMSharedData.verifyCode = nil
        examTimer.invalidate()
    }
}

extension HMVerifyVC: SwiftyCodeViewDelegate {
    func codeView(sender: SwiftyCodeView, didFinishInput code: String) {
        inputCode = code
    }
}
