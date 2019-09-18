//
//  HMUpdateProfileVC.swift
//  Develop
//
//  Created by RTC-HN360 on 7/27/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import Kingfisher

class HMUpdateProfileVC: HMBaseVC {

    // MARK: - Outlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var emailTf: UITextField!
    @IBOutlet weak var nameTf: UITextField!
    @IBOutlet weak var birthdayTf: HMNoCursorTextField!
    @IBOutlet weak var weightTf: UITextField!
    @IBOutlet weak var heightTf: UITextField!
    @IBOutlet weak var genderTf: UITextField!
    @IBOutlet weak var cityTf: UITextField!
    @IBOutlet weak var passwordTf: UITextField!
    @IBOutlet weak var avatar: UIImageView!
    
    // MARK: - Variables
    var userInfo:HMUserInfoEntity? = nil {
        didSet {
            emailTf.text = userInfo?.email
            nameTf.text = userInfo?.name
            birthdayTf.text = userInfo?.birthday
            weightTf.text = userInfo?.weight
            heightTf.text = userInfo?.height
            genderTf.text = userInfo?.gender == .male ? "Nam" : "Nữ"
            cityTf.text = userInfo?.address
            passwordTf.text = userInfo?.password
            if let avatarURL = URL(string: userInfo?.avatar ?? "") {
                self.avatar.kf.setImage(with: avatarURL)
            }
        }
    }
    var isRegister: Bool = false
    
    // MARK: - Constants
    private let datePicker = UIDatePicker()
    
    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = isRegister
        if !isRegister {
            fetchData()
        }
    }

    override func setupView() {
        super.setupView()
        
        createPlaceToolbar()
    }
    
    // MARK: - Management Data
    private func fetchData() {
        HMUserInfoAPI().execute(target: self, success: {[weak self] (response) in
            guard let sSelf = self else { return }
            switch response.errorId {
            case HMErrorCode.success.rawValue:
                sSelf.userInfo = response.userInfo
            case HMErrorCode.error.rawValue:
                UIAlertController.showQuickSystemAlert(message: response.message, cancelButtonTitle: "Đồng ý")
            default:
                break
            }
            }, failure: { (error) in
                UIAlertController.showQuickSystemAlert(message: error.message, cancelButtonTitle: "Đồng ý")
        })
    }
    
    // MARK: - Actions
    @IBAction func updateProfile(_ sender: UIButton) {
        guard let parameter = getParameters() else { return }
        HMUpdateProfileAPI(parameter: parameter).execute(target: self, success: { (response) in
            switch response.errorId {
            case HMErrorCode.success.rawValue:
                var window = UIApplication.shared.keyWindow
                let rootVC = UINavigationController(rootViewController: HMHomeVC.create())
                HMSystemBoots.instance.changeRoot(window: &window, rootController: rootVC)
            case HMErrorCode.error.rawValue:
                UIAlertController.showQuickSystemAlert(message: response.message, cancelButtonTitle: "Đồng ý")
            default:
                break
            }
        }, failure: { (error) in
            UIAlertController.showQuickSystemAlert(message: error.message, cancelButtonTitle: "Đồng ý")
        })
    }
    
    @IBAction func invokeUpLoadAvatarButton(_ sender: UIButton) {
        HMCameraPhotoService.instance.showActionSheetPickupImage { [weak self] (image) in
            guard let image = image,
                let imageData = HMCameraPhotoService.compressImage(sourceImage: image) else {
                    return
            }
            self?.avatar.image = image
            HMUpdateAvaterAPI(image: imageData).execute(target: self, success: { (response) in
                switch response.errorId {
                case HMErrorCode.success.rawValue:
                    break
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
    
    @IBAction func invokePickBirthDay(_ sender: UITextField) {
        showDatePicker()
    }
    
    // MARK: - Private method
    private func showDatePicker() {
        //Formate Date
        datePicker.datePickerMode = .date
        //ToolBar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneDatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
        toolbar.setItems([doneButton, spaceButton, cancelButton], animated: false)
        
        birthdayTf.inputAccessoryView = toolbar
        birthdayTf.inputView = datePicker
    }
    
    @objc private func doneDatePicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = Date.dateFormatS
        
        birthdayTf.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc private func cancelDatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = Date.dateFormatS
        
        birthdayTf.text = formatter.string(from: Date())
        self.view.endEditing(true)
    }
 
    private func createPlaceToolbar() {
        let genderPicker = UIPickerView()
        genderPicker.tag = 0
        genderPicker.delegate = self
        
        let cityPicker = UIPickerView()
        cityPicker.tag = 1
        cityPicker.delegate = self
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Xong", style: .plain, target: self, action: #selector(doneFixedPickerView))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Huỷ", style: .plain, target: self, action: #selector(cancelFixedPickerView))
        toolbar.setItems([doneButton, spaceButton, cancelButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        if let genderTf = genderTf {
            genderTf.inputAccessoryView = toolbar
            genderTf.inputView = genderPicker
        }
        if let cityTf = cityTf {
            cityTf.inputAccessoryView = toolbar
            cityTf.inputView = cityPicker
        }
    }
    
    @objc private func doneFixedPickerView() {
        view.endEditing(true)
    }
    
    @objc private func cancelFixedPickerView() {
        view.endEditing(true)
    }
    
    private func getParameters() -> [String: Any]? {
        
        guard let email = emailTf.text, email.isEmail else {
            UIAlertController.showQuickSystemAlert(message: "Email của bạn không đúng !", cancelButtonTitle: "Đồng ý")
            return nil
        }
        
        guard let name = nameTf.text, !name.isEmpty else {
            UIAlertController.showQuickSystemAlert(message: "Nhập tên của bạn !", cancelButtonTitle: "Đồng ý")
            return nil
        }
        
        guard let birthday = birthdayTf.text ,
            let weight = weightTf.text,
            let height = heightTf.text else {
            return nil
        }
        
        guard let gender = genderTf.text, !gender.isEmpty else {
            UIAlertController.showQuickSystemAlert(message: "Chọn giới tính của bạn !", cancelButtonTitle: "Đồng ý")
            return nil
        }
        
        guard let city = cityTf.text, !city.isEmpty else {
            UIAlertController.showQuickSystemAlert(message: "Chọn thành phố của bạn !", cancelButtonTitle: "Đồng ý")
            return nil
        }
        
        guard let password = passwordTf.text, !password.isEmpty else {
            UIAlertController.showQuickSystemAlert(message: "Nhập mật khẩu của bạn !", cancelButtonTitle: "Đồng ý")
            return nil
        }
        
        return ["id": HMSharedData.userId!,
                "email": email,
                "name": name,
                "birthday": birthday,
                "weight": weight,
                "height": height,
                "gender": genderTf.tag,
                "address": city,
                "password": password]
    }
}

extension HMUpdateProfileVC: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 0:
            return HMConstants.genders.count
        case 1:
            return HMConstants.cities.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 0:
            return HMConstants.genders[row]
        case 1:
            return HMConstants.cities[row]
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 0:
            genderTf.tag = row
            genderTf.text = HMConstants.genders[row]
        case 1:
            cityTf.text = HMConstants.cities[row]
        default:
            break
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30.0
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label: UILabel
        if let view = view as? UILabel{
            label = view
        } else {
            label = UILabel()
        }
        
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16.0)
        
        switch pickerView.tag {
        case 0:
            label.text = HMConstants.genders[row]
        case 1:
            label.text = HMConstants.cities[row]
        default:
            break
        }
        
        return label
    }
}
