//
//  HMUpdateDataVC.swift
//  SwequityVN
//
//  Created by RTC-HN360 on 7/30/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class HMUpdateDataVC: HMBaseVC {
    
    @IBOutlet weak var weightTf: UITextField!
    @IBOutlet weak var khoiLuongMoTf: UITextField!
    @IBOutlet weak var khoiLuongNacTf: UITextField!
    @IBOutlet weak var ngucTf: UITextField!
    @IBOutlet weak var vaiTf: UITextField!
    @IBOutlet weak var bapTraiTf: UITextField!
    @IBOutlet weak var bapPhaiTf: UITextField!
    @IBOutlet weak var cangTayTraiTf: UITextField!
    @IBOutlet weak var cangTayPhaiTf: UITextField!
    @IBOutlet weak var eoTf: UITextField!
    @IBOutlet weak var mongTf: UITextField!
    @IBOutlet weak var bungNgangRonTf: UITextField!
    @IBOutlet weak var duiTraiTf: UITextField!
    @IBOutlet weak var duiPhaiTf: UITextField!
    @IBOutlet weak var bapchuoiTraiTf: UITextField!
    @IBOutlet weak var bapchuoiPhaiTf: UITextField!
    
    var bodyInfo: HMBodyInfoEntity? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let rightBarButton: UIBarButtonItem = UIBarButtonItem(title: "Lưu", style: .done, target: self, action: #selector(saveData))
        self.navigationItem.rightBarButtonItem = rightBarButton
        titleScreen = "Cập nhật dữ liệu"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchData()
    }
    
    private func fetchData() {
        self.weightTf.text = self.bodyInfo?.khoiluong
        self.khoiLuongMoTf.text = self.bodyInfo?.khoiluongmo
        self.khoiLuongNacTf.text = self.bodyInfo?.khoiluongnac
        self.ngucTf.text = self.bodyInfo?.nguc
        self.vaiTf.text = self.bodyInfo?.vai
        self.bapTraiTf.text = self.bodyInfo?.baptrai
        self.bapPhaiTf.text = self.bodyInfo?.bapphai
        self.cangTayTraiTf.text = self.bodyInfo?.cangtaytrai
        self.cangTayPhaiTf.text = self.bodyInfo?.cangtayphai
        self.eoTf.text = self.bodyInfo?.eo
        self.mongTf.text = self.bodyInfo?.mong
        self.bungNgangRonTf.text = self.bodyInfo?.bungngangron
        self.duiTraiTf.text = self.bodyInfo?.duitrai
        self.duiPhaiTf.text = self.bodyInfo?.duiphai
        self.bapchuoiTraiTf.text = self.bodyInfo?.bapchuoitrai
        self.bapchuoiPhaiTf.text = self.bodyInfo?.bapchuoiphai
    }
    
    @objc func saveData() {
        var parameter: Parameters = Parameters()
        parameter = [
            "id": HMSharedData.userId!,
            "khoiluong": self.weightTf.text ?? "0",
            "khoiluongmo": self.khoiLuongMoTf.text ?? "0",
            "khoiluongnac": self.khoiLuongNacTf.text ?? "0",
            "nguc": self.ngucTf.text ?? "0",
            "vai": self.vaiTf.text ?? "0",
            "baptrai": self.bapTraiTf.text ?? "0",
            "bapphai": self.bapPhaiTf.text ?? "0",
            "cangtaytrai": self.cangTayTraiTf.text ?? "0",
            "cangtayphai": self.cangTayPhaiTf.text ?? "0",
            "eo": self.eoTf.text ?? "0",
            "mong": self.mongTf.text ?? "0",
            "bungngangron": self.bungNgangRonTf.text ?? "0",
            "duitrai": self.duiTraiTf.text ?? "0",
            "duiphai": self.duiPhaiTf.text ?? "0",
            "bapchuoitrai": self.bapchuoiTraiTf.text ?? "0",
            "bapchuoiphai": self.bapchuoiPhaiTf.text ?? "0"]
        HMUpdateBodyDataAPI.init(parameter: parameter).execute(target: self, success: { (response) in
            switch response.errorId {
            case HMErrorCode.success.rawValue:
                self.pop()
                break
            case HMErrorCode.error.rawValue:
                UIAlertController.showQuickSystemAlert(message: response.message, cancelButtonTitle: "Đồng ý")
            default:
                break
            }
        }, failure: { (error) in
            
        })
    }

}
