//
//  HMEditExAlertVC.swift
//  SwequityVN
//
//  Created by RTC-HN360 on 7/30/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

protocol HMEditExAlertVCDelegate:NSObject {
    func updateExList()
}

class HMEditExAlertVC: HMBaseVC {

    
    @IBOutlet weak var roundTf: UITextField!
    @IBOutlet weak var repeatTf: UITextField!
    @IBOutlet weak var relaxTf: UITextField!
    
    weak var delegate:HMEditExAlertVCDelegate?
    var exDetail:HMExerciseInSessionDetailEntity?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func invokeCloseButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapSaveButton(_ sender: UIButton) {
        var parameterUpdateRound: Parameters = Parameters()
        var parameterUpdateEx: Parameters = Parameters()
        parameterUpdateEx = [
            "session_id": self.exDetail?.session_id ?? "",
            "ex_id": self.exDetail?.ex_id ?? "",
            "sets": self.roundTf.text ?? "0",
            "reps": self.repeatTf.text ?? "0",
            "break_time": self.relaxTf.text ?? "0"]
        
        let listParameterDict = self.getParameterForEx()
        
        if let theJSONData = try?  JSONSerialization.data(
            withJSONObject: listParameterDict),
            
            let theJSONText = String(data: theJSONData,
                                     encoding: .utf8) {
            parameterUpdateRound = [
                "user_id": HMSharedData.userId!,
                "session_id": self.exDetail?.session_id ?? "",
                "ex_id": self.exDetail?.ex_id ?? "",
                "sets": theJSONText]
            HMUpdateExInSessionAPI.init(parameter: parameterUpdateEx).execute(target: self, success: { (response) in
                HMUpdateRoundAPI.init(parameter: parameterUpdateRound).execute(target: self, success: { (response) in
                    self.delegate?.updateExList()
                    self.dismiss(animated: true, completion: nil)
                }, failure: { (error) in
                    
                })
            }, failure: { (error) in
                
            })
        }
    }
    
    func getParameterForEx() -> [[String: Any]] {
        let parameterDict:[String: Any] = ["rm": 0.0,
                                           "isCount": false,
                                           "number": Int(self.repeatTf.text ?? "0") ?? 0,
                                           "break_time": 0,
                                           "weight": 0]
        var listParameterDict = [[String: Any]]()
        if let setString = self.roundTf.text {
            let sets = Int(setString) ?? 0
            for _ in 0..<sets {
                listParameterDict.append(parameterDict)
            }
        }
        return listParameterDict
    }
    
}
