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

class HMHomeVC: HMBaseVC {

    // MARK: - Outlets
    @IBOutlet weak var chartView: LineChartView!
    
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
        updateChartData(datas: [4,2,2,1])
    }
    
    private func updateChartData(datas: [Int] = []) {
        let values = (0..<datas.count).map { (i) -> ChartDataEntry in
            let val = datas[i]
            return ChartDataEntry(x: Double(i), y: Double(val), icon: nil)
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
    // MARK: - Private
}

extension HMHomeVC: ChartViewDelegate {
    
}
