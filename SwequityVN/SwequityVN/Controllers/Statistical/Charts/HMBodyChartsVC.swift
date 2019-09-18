//
//  HMBodyChartsVC.swift
//  SwequityVN
//
//  Created by NamNH-D1 on 8/5/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import Charts
import RxCocoa
import RxSwift

struct BodyChartMenu {
    let key: String
    let title: String
}

enum MonthType: Int {
    case one = 1
    case three = 3
    case six = 6
    case twelve = 12
}

class HMBodyChartsVC: HMBaseVC {
    
    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var chartView: LineChartView!
    
    // MARK: - Variables
    private var numberMonth: String = "1"
    private var key: String = "khoiluongcothe"
    
    // MARK: - Constant
    private let menus: [BodyChartMenu] = [BodyChartMenu(key: "khoiluongcothe", title: "Khối lượng cơ thể"),
                                          BodyChartMenu(key: "khoiluongmo", title: "Khối lượng mỡ"),
                                          BodyChartMenu(key: "khoiluongnac", title: "Khối lượng nạc"),
                                          BodyChartMenu(key: "nguc", title: "Ngực"),
                                          BodyChartMenu(key: "vai", title: "Vai"),
                                          BodyChartMenu(key: "baptrai", title: "Bắp trái"),
                                          BodyChartMenu(key: "bapphai", title: "Bắp phải"),
                                          BodyChartMenu(key: "cangtaytrai", title: "Cẳng tay trái"),
                                          BodyChartMenu(key: "cangtayphai", title: "Cẳng tay phải"),
                                          BodyChartMenu(key: "eo", title: "Eo"),
                                          BodyChartMenu(key: "mong", title: "Mông"),
                                          BodyChartMenu(key: "bungngangron", title: "Bụng ngang rốn"),
                                          BodyChartMenu(key: "duitrai", title: "Đùi trái"),
                                          BodyChartMenu(key: "duiphai", title: "Đùi phải"),
                                          BodyChartMenu(key: "bapchuoitrai", title: "Bắp chuối trái"),
                                          BodyChartMenu(key: "bapchuoiphai", title: "Bắp chuối phải")]
    
    private let disposeBag = DisposeBag()
    private let listBodyTitles: BehaviorRelay<[BodyChartMenu]> = BehaviorRelay(value: [])
    
    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        UINavigationController.attemptRotationToDeviceOrientation()
    }
    
    // MARK: - Setup views
    override func setupView() {
        super.setupView()
        
        titleScreen = menus.first?.title
        key = menus.first!.key
        fetchData(key: key)
        
        setupChart()
        setupCollectionView()
        manageMenuTitles()
        addMenuNavigationBarbutton()
    }
    
    private func setupChart() {
        chartView.delegate = self
        
        chartView.chartDescription?.enabled = true
        chartView.dragEnabled = false
        chartView.setScaleEnabled(false)
        
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = UIFont(name: "OpenSans-Semibold", size: 14.0)!
        xAxis.axisMaximum = 30
        xAxis.axisMinimum = 0
//        xAxis.granularity = 1
        xAxis.axisMaxLabels = 31
        xAxis.setLabelCount(31, force: true)
        
        let leftAxis = chartView.leftAxis
        leftAxis.removeAllLimitLines()
        leftAxis.labelFont = UIFont(name: "OpenSans-Semibold", size: 14.0)!
        leftAxis.labelTextColor = UIColor(red: 155, green: 155, blue: 155)
        leftAxis.axisMaximum = 150
        leftAxis.granularity = 30
        leftAxis.axisMinimum = 0
        leftAxis.drawLimitLinesBehindDataEnabled = false
        
        //
        chartView.rightAxis.enabled = false
        chartView.legend.enabled = false
        // Remove grid
        chartView.xAxis.drawAxisLineEnabled = false
        chartView.xAxis.drawGridLinesEnabled = false
        
        chartView.animate(xAxisDuration: 0)
    }
    
    private func setupCollectionView() {
        collectionView.registerNibCellFor(type: HMMenuTitleCell.self)
        
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 1, height: 1)
        }
        
        listBodyTitles.bind(to: collectionView.rx.items(cellIdentifier: "HMMenuTitleCell", cellType: HMMenuTitleCell.self)) { row, model, cell in
            cell.menuTitleLB.text = model.title
            cell.menuTitleLB.preferredMaxLayoutWidth = self.collectionView.frame.size.width - 20.0
            }.disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(BodyChartMenu.self).subscribe(onNext: {[weak self] menu in
            guard let sSelf = self else { return }
            sSelf.titleScreen = menu.title
            sSelf.key = menu.key
            sSelf.fetchData(key: menu.key)
        }).disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .subscribe({ indexPath in
            }).disposed(by: disposeBag)
        
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    // MARK: - Management Data
    private func manageMenuTitles() {
        listBodyTitles.accept(menus)
    }
    
    private func fetchData(key: String) {
        HMBodyDataAPI(numberMonth: numberMonth, key: key).execute(target: self, success: {[weak self] (response) in
            guard let sSelf = self else { return }
            var datas = response.bodyData.compactMap({
                return $0.value
            })
            
//            datas.insert("0", at: 0)
            sSelf.updateChartData(datas: datas)
        }) { (error) in
            
        }
    }
    
    private func updateChartData(datas: [String] = []) {
        let values = (0..<datas.count).map { (i) -> ChartDataEntry in
            let val = datas[i]
            return ChartDataEntry(x: Double(i), y: Double(val) ?? 0.0, icon: nil)
        }
        
        let set = LineChartDataSet(entries: values, label: nil)
        set.drawIconsEnabled = false
        
        set.lineDashLengths = [5, 2.5]
        set.highlightLineDashLengths = [5, 2.5]
        set.lineWidth = 1
        set.circleRadius = 3
        set.drawCircleHoleEnabled = false
        set.valueFont = UIFont(name: "OpenSans-Semibold", size: 10.0)!
        set.formLineDashLengths = [5, 2.5]
        set.formLineWidth = 1
        set.formSize = 15
        
        let data = LineChartData(dataSet: set)
        
        chartView.data = data
    }
    
    // MARK: - Private method
    private func addMenuNavigationBarbutton() {
        let oneMonthButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 20))
        oneMonthButton.setTitle("1T", for: .normal)
        oneMonthButton.setTitleColor(UIColor.charcoalGrey50, for: .normal)
        oneMonthButton.tag = MonthType.one.rawValue
        oneMonthButton.cornerRadius = 8.0
        oneMonthButton.borderWidth = 1.0
        oneMonthButton.borderColor = UIColor.dustyOrange
        let threeMonthButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 20))
        threeMonthButton.setTitle("3T", for: .normal)
        threeMonthButton.setTitleColor(UIColor.charcoalGrey50, for: .normal)
        threeMonthButton.tag = MonthType.three.rawValue
        threeMonthButton.cornerRadius = 8.0
        threeMonthButton.borderWidth = 1.0
        threeMonthButton.borderColor = UIColor.dustyOrange
        let sixMonthButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 20))
        sixMonthButton.setTitle("6T", for: .normal)
        sixMonthButton.setTitleColor(UIColor.charcoalGrey50, for: .normal)
        sixMonthButton.tag = MonthType.six.rawValue
        sixMonthButton.cornerRadius = 8.0
        sixMonthButton.borderWidth = 1.0
        sixMonthButton.borderColor = UIColor.dustyOrange
        let twelveMonthButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 20))
        twelveMonthButton.setTitle("1N", for: .normal)
        twelveMonthButton.setTitleColor(UIColor.charcoalGrey50, for: .normal)
        twelveMonthButton.tag = MonthType.twelve.rawValue
        twelveMonthButton.cornerRadius = 8.0
        twelveMonthButton.borderWidth = 1.0
        twelveMonthButton.borderColor = UIColor.dustyOrange
        
        oneMonthButton.addTarget(self, action: #selector(invokeChangeTypeMonth(_:)), for: .touchUpInside)
        threeMonthButton.addTarget(self, action: #selector(invokeChangeTypeMonth(_:)), for: .touchUpInside)
        sixMonthButton.addTarget(self, action: #selector(invokeChangeTypeMonth(_:)), for: .touchUpInside)
        twelveMonthButton.addTarget(self, action: #selector(invokeChangeTypeMonth(_:)), for: .touchUpInside)
        
        let oneMonthItem = UIBarButtonItem.init(customView: oneMonthButton)
        let threeMonthItem = UIBarButtonItem.init(customView: threeMonthButton)
        let sixMonthItem = UIBarButtonItem.init(customView: sixMonthButton)
        let twelveMonthItem = UIBarButtonItem.init(customView: twelveMonthButton)
        
        let backView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        let backButton = UIButton(frame: backView.frame)
        backButton.addTarget(self, action: #selector(invokeButtonBack(_:)), for: .touchUpInside)
        
        let backImageView = UIImageView(frame: CGRect(x: 0, y: 10, width: 20, height: 20))
        backImageView.image = UIImage(named: "icon_back")
        backView.addSubview(backImageView)
        backView.addSubview(backButton)
        
        let backItem = UIBarButtonItem.init(customView: backView)
        
        navigationItem.leftBarButtonItems = [backItem, oneMonthItem, threeMonthItem, sixMonthItem, twelveMonthItem]
    }
    
    @objc private func invokeChangeTypeMonth(_ sender: UIButton) {
        numberMonth = "\(sender.tag)"
        
        var granularity:Double = 1
        var labelCount = 31
        var max:Double = Double(30 * sender.tag)
        switch MonthType(rawValue: sender.tag) {
        case .one?:
            granularity = 1
            max = Double(30 * sender.tag)
            labelCount = Int(lround(max / granularity)) + 1
        case .three?:
            granularity = 3
            max = Double(30 * sender.tag)
            labelCount = Int(lround(max / granularity)) + 1
        default:
            granularity = 10
            max = Double(30 * sender.tag)
            labelCount = Int(lround(max / granularity)) + 1
        }
        chartView.xAxis.granularity = granularity
        chartView.xAxis.axisMaximum = max
        chartView.xAxis.axisMinLabels = labelCount - 2
        chartView.xAxis.axisMaxLabels = labelCount
        chartView.xAxis.setLabelCount(labelCount, force: true)
        fetchData(key: key)
    }
    
    @objc private func invokeButtonBack(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    // MARK: - Override method
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
}

extension HMBodyChartsVC: ChartViewDelegate {
    
}

extension HMBodyChartsVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let str = menus[indexPath.row].title
        let font = UIFont(name: "OpenSans-Semibold", size: 16.0)!
        
        let width = str.width(withHeight: collectionView.frame.height, font: font)
        
        return CGSize(width: width + 20, height: collectionView.frame.height)
    }
}

