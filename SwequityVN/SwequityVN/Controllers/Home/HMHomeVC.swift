//
//  HMHomeVC.swift
//  SwequityVN
//
//  Created by NamNH-D1 on 7/24/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import SideMenu
import Charts
import Kingfisher

class HMHomeVC: HMBaseVC {

    // MARK: - Outlets
    @IBOutlet weak var chartView: LineChartView!
    
    @IBOutlet weak var premiumLB: UILabel!
    @IBOutlet weak var weightLB: UILabel!
    @IBOutlet weak var numberImageLB: UILabel!
    @IBOutlet weak var fatLB: UILabel!
    @IBOutlet weak var workoutExLB: UILabel!
    @IBOutlet weak var welcomeLB: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    
    // MARK: - Variables
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchData()
    }
    // MARK: - SetupViews
    
    override func setupView() {
        super.setupView()
        
        setupSideMenu()
        setupChart()
    }

    private func setupSideMenu() {
        // Define the menus
        let menuLeft = UISideMenuNavigationController(rootViewController: HMMenuVC.create())
        menuLeft.settings = makeSettings()
        SideMenuManager.default.leftMenuNavigationController = menuLeft
        
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: self.view)
    }
    
    private func makeSettings() -> SideMenuSettings {
        let presentationStyle: SideMenuPresentationStyle = .menuSlideIn
        presentationStyle.presentingEndAlpha = 0.8
        
        var settings = SideMenuSettings()
        settings.presentationStyle = presentationStyle
        settings.menuWidth = HMSystemInfo.screenWidth * 0.75
        settings.statusBarEndAlpha = 0
        return settings
    }
    
    private func setupChart() {
        chartView.delegate = self
        
        chartView.chartDescription?.enabled = true
        chartView.dragEnabled = false
        chartView.setScaleEnabled(false)
        
        let leftAxis = chartView.leftAxis
        leftAxis.removeAllLimitLines()
        leftAxis.labelFont = UIFont(name: "OpenSans-Semibold", size: 14.0)!
        leftAxis.labelTextColor = UIColor(red: 155, green: 155, blue: 155)
        leftAxis.axisMaximum = 5
        leftAxis.granularity = 1
        leftAxis.axisMinimum = 0
        leftAxis.drawLimitLinesBehindDataEnabled = false
        
        //
        chartView.rightAxis.enabled = false
        chartView.legend.enabled = false
        
        // Remove grid
        chartView.xAxis.drawAxisLineEnabled = false
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.xAxis.drawLabelsEnabled = false
        
        chartView.animate(xAxisDuration: 0)
    }
    
    // MARK: - Management Datas
    private func fetchData() {
        HMUserInfoAPI().execute(target: self, success: {[weak self] (response) in
            guard let sSelf = self else { return }
            switch response.errorId {
            case HMErrorCode.success.rawValue:
                if let userInfo = response.userInfo {
                    sSelf.didFetchUserInfo(userInfo: userInfo)
                }
            case HMErrorCode.error.rawValue:
                UIAlertController.showQuickSystemAlert(message: response.message, cancelButtonTitle: "Đồng ý")
            default:
                break
            }
        }, failure: { (error) in
            UIAlertController.showQuickSystemAlert(message: error.message, cancelButtonTitle: "Đồng ý")
        })
    }
    
    private func didFetchUserInfo(userInfo: HMUserInfoEntity) {
        
        updateChartData(datas: [userInfo.week_1 ?? "0.0",
                                userInfo.week_2 ?? "0.0",
                                userInfo.week_3 ?? "0.0",
                                userInfo.week_4 ?? "0.0"])
        
        let attributedString = NSMutableAttributedString(string: "\(userInfo.weight)kg", attributes: [
            .font: UIFont(name: "OpenSans-Semibold", size: 25.0)!,
            .foregroundColor: UIColor.black
            ])
        attributedString.addAttribute(.font, value: UIFont(name: "OpenSans-Semibold", size: 14.0)!, range: NSRange(location: userInfo.weight.count, length: 2))
        
        weightLB.attributedText = attributedString
        
        numberImageLB.text = userInfo.image
        fatLB.text = userInfo.fat
        workoutExLB.text = userInfo.ex
        welcomeLB.text = "Xin chào! \(userInfo.name)"
        if let avatarURL = URL(string: userInfo.avatar) {
            avatar.kf.setImage(with: avatarURL)
        }
        premiumLB.text = (userInfo.type == .normal) ? "Thành viên thường" : "Thành viên VIP"
    }
    
    private func updateChartData(datas: [String] = []) {
        let values = (0..<datas.count).map { (i) -> ChartDataEntry in
            let val = datas[i]
            return ChartDataEntry(x: Double(i), y: Double(val) ?? 0.0, icon: nil)
        }
        
        let set = LineChartDataSet(entries: values, label: nil)
        set.drawIconsEnabled = true
        set.drawValuesEnabled = false
        
        let gradientColors = [ChartColorTemplates.colorFromString("#89B8F0").cgColor,
                              ChartColorTemplates.colorFromString("#89B8F0").cgColor]
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
        
        set.fillAlpha = 0.5
        set.fill = Fill(linearGradient: gradient, angle: 90)
        set.drawFilledEnabled = true
        
        let data = LineChartData(dataSet: set)
        
        chartView.data = data
    }
    
    // MARK: - Actions
    
    @IBAction func invokeWorkoutButton(_ sender: UIButton) {
        HMDiaryVC.push()
    }
    
    @IBAction func invokeStatisticalButton(_ sender: UIButton) {
        HMStatisticalVC.push()
    }
    
    @IBAction func invokeBodyImageButton(_ sender: UIButton) {
        HMStatisticalVC.push(prepare: { vc in
            vc.menuType = .image
        })
    }
    
    // MARK: - Private
}

extension HMHomeVC: ChartViewDelegate {
    
}
