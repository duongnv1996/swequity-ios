//
//  HMNutritionGoalVC.swift
//  SwequityVN
//
//  Created by Tung QT on 7/27/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

enum CellModel<T> {
    case standard(T)
}

class HMNutritionGoalVC: HMBaseVC {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Variables
    private let disposeBag = DisposeBag()
    private var lists: BehaviorRelay<[AnyObject]> = BehaviorRelay(value: [])
    private let sections: BehaviorRelay<[SectionModel<String, CellModel<AnyObject>>]> = BehaviorRelay(value: [])
    
    private var userInfo:HMUserInfoEntity?
    private var foodList:HMFoodListEntity?
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadWhenBackScreen), name: NSNotification.Name(rawValue: HMConstants.kReloadNutritionGoal), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: HMConstants.kReloadNutritionGoal), object: nil)
    }
    
    // MARK: - Setup views
    override func setupView() {
        super.setupView()
        titleScreen = "Mục tiêu dinh dưỡng"
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.registerNibCellFor(type: HMNutritionGoal001Cell.self)
        tableView.registerNibCellFor(type: HMNutritionGoal002Cell.self)
        tableView.registerNibCellFor(type: HMNutritionGoal003Cell.self)
        tableView.registerNibCellFor(type: HMNutritionGoal004Cell.self)
        tableView.registerNibCellFor(type: HMNutritionGoal005Cell.self)
        
        // Cách 1 : Sử dụng với nhiều loại cell trong 1 sections
        lists.bind(to: tableView.rx.items) { table, index, element in
            return self.makeCell(with: element, from: table)
        }.disposed(by: disposeBag)
        
        // Cách 2 : Sử dụng với nhiều loại cell trong nhiều loại sections
//        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, CellModel<AnyObject>>>(configureCell: { dataSource, table, indexPath, item in
//            switch item {
//            case .standard(let data):
//                return self.makeCell(with: data, from: table)
//            }
//        })
//
//        dataSource.titleForHeaderInSection = { dataSource, index in
//            return (dataSource.sectionModels[index].model)
//        }
//
//        sections
//            .bind(to: tableView.rx.items(dataSource: dataSource))
//            .disposed(by: disposeBag)
    }
    
    // MARK: - Private method
    private func makeCell(with entity: AnyObject, from table: UITableView) -> UITableViewCell {
        switch entity {
        case is HMNutritionGoal001Entity:
            guard let cell = table.reusableCell(type: HMNutritionGoal001Cell.self) else { return UITableViewCell() }
            cell.delegate = self
            cell.data = entity
            return cell
        case is HMNutritionGoal002Entity:
            guard let cell = table.reusableCell(type: HMNutritionGoal002Cell.self) else { return UITableViewCell() }
            cell.delegate = self
            cell.data = entity
            return cell
        case is HMNutritionGoal004Entity:
            guard let cell = table.reusableCell(type: HMNutritionGoal004Cell.self) else { return UITableViewCell() }
            cell.delegate = self
            cell.data = entity
            return cell
        case is HMNutritionGoal005Entity:
            guard let cell = table.reusableCell(type: HMNutritionGoal005Cell.self) else { return UITableViewCell() }
            cell.delegate = self
            cell.data = entity
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    
    // MARK: - Management datas
    private func fetchData() {
        HMFoodListAPI().execute(target: self, success: { (response) in
            switch response.errorId {
            case HMErrorCode.success.rawValue:
                self.foodList = response.foodList
                let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
                appDelegate?.foodList = response.foodList
                self.fetchListFood()
                break
            case HMErrorCode.error.rawValue:
                UIAlertController.showQuickSystemAlert(message: response.message, cancelButtonTitle: "Đồng ý")
            default:
                break
            }
        }) { (error) in
            
        }
        
//        let sectionValues: [CellModel<AnyObject>] = [
//            CellModel.standard(HMNutritionGoal001Entity(titleName: "Mục tiêu", subTitle001: "Số cân hiện tại", subTitle002: "Mục tiêu tuần", subTitle003: "Tỉ lệ mỡ", weightCurrent: "65", weightTarget: "66", fatPercent: "12", currentDate: "5/11/2018", targetDate: "12/11/2018")),
//            CellModel.standard(HMNutritionGoal002Entity(titleName: "test1", foods: ["test1", "test1"], subTitleName: "test1", caloValue: "test1")),
//        ]
//
//        let section1 = SectionModel(model: "Standard Items", items: sectionValues)
//        sections.accept([section1])
    }
    
    private func fetchListFood() {
        let weight = self.foodList?.target?.khoiluong ?? "0"
        let targetWeek = self.foodList?.target?.khoiluongmuctieu ?? "0"
        let total = Double(self.foodList?.target?.total ?? "1") ?? 1
        let tyleMo = self.foodList?.target?.tylemo ?? "0"
        let fat = Double(self.foodList?.target?.fat ?? "0") ?? 0
        let gluco = Double(self.foodList?.target?.carb ?? "0") ?? 0
        let protein = Double(self.foodList?.target?.protein ?? "0") ?? 0
        let date = self.foodList?.target?.time_update ?? "0"
        let targetDate = self.foodList?.target?.time_update_target_week ?? "0"
        let actionLevel = self.foodList?.target?.mucdovandong ?? "Không vận động"
        let foodList = self.foodList?.food ?? []
        let favFoodList = self.foodList?.food_favourite ?? []
        let totolFoodCalo = Float(self.foodList?.target?.total ?? "0") ?? 0
        
        let value1 = HMNutritionGoal001Entity(titleName: "Mục tiêu", subTitle001: "Số cân hiện tại", subTitle002: "Mục tiêu tuần", subTitle003: "Tỉ lệ mỡ", weightCurrent: weight, weightTarget: targetWeek, fatPercent: tyleMo, currentDate: date, targetDate: targetDate)
        let value2 = HMNutritionGoal002Entity(titleName: "Danh sách món ăn", foods: foodList, favFoods: favFoodList, subTitleName: "Giá trị Calo mong muốn", caloValue: String(Int(round(totolFoodCalo * pow(10, 0))/pow(10, 0))))
        let value4 = HMNutritionGoal004Entity(titleName: "Mức độ vận động", statusTort: actionLevel)
        var perFat = 0
        var perGlu = 0
        var perCalo = 0
        if total != 0 {
            perFat = Int(round(((fat/total) * 100.0) * pow(10, 0))/pow(10, 0))
            perGlu = Int(round(((protein/total) * 100.0) * pow(10, 0))/pow(10, 0))
            perCalo = Int(round(((gluco/total) * 100.0) * pow(10, 0))/pow(10, 0))
        }
        let elementFood1 = ElementFood(titleName: "Chất béo", percent: perFat, calo: fat)
        let elementFood2 = ElementFood(titleName: "Protein", percent: perGlu, calo: protein)
        let elementFood3 = ElementFood(titleName: "Tinh bột", percent:
            perCalo, calo: gluco)
        let value5 = HMNutritionGoal005Entity(titleName: "Giá trị dinh duỡng mong muốn", caloValue: "\(total)", elementFoods: [elementFood1, elementFood2,elementFood3])
        lists.accept([value1,value4,value5,value2])
    }
    
    private func findEntityWithId(id: String, withArray arrayList:Array<HMTargetDetailEntity>) -> HMTargetDetailEntity? {
        for (_, value) in arrayList.enumerated() {
            if  String(value.id) == id {
                return value
            }
        }
        return nil
    }
    
    @objc private func reloadWhenBackScreen () {
        self.fetchData()
    }
    
}

extension HMNutritionGoalVC: HMNutritionGoal001Delegate {
    func tapToEdit() {
        print("///////////// Tap To Edit")
    }
    
    func didTapEditWeightButton() {
        let nutritonTarget = HMNutritonTargetVC.create()
        nutritonTarget.value = self.foodList?.target?.khoiluong ?? "0"
        nutritonTarget.type = HMTargetFillType.weight
        let popupVC = HMPopUpViewController(contentController: nutritonTarget, position: .bottom(0), popupWidth: HMSystemInfo.screenWidth, popupHeight: HMSystemInfo.screenHeight)
        popupVC.backgroundAlpha = 0.3
        popupVC.cornerRadius = 0
        popupVC.shadowEnabled = false
        present(popupVC, animated: true, completion: nil)
    }
    
    func didTapTargetWeekButton() {
        let nutritonTarget = HMNutritonTargetWeekTargetVC.create()
        guard let listTarget = self.foodList?.target_week else { return }
        nutritonTarget.listTarget.accept(listTarget)
        nutritonTarget.targetValue = self.findEntityWithId(id: self.foodList?.target?.id_target_week ?? "1", withArray: listTarget)
        let popupVC = HMPopUpViewController(contentController: nutritonTarget, position: .bottom(0), popupWidth: HMSystemInfo.screenWidth, popupHeight: HMSystemInfo.screenHeight)
        popupVC.backgroundAlpha = 0.3
        popupVC.cornerRadius = 0
        popupVC.shadowEnabled = false
        present(popupVC, animated: true, completion: nil)
    }
    
    func didTapRatioFatButton() {
        let nutritonTarget = HMNutritonTargetVC.create()
        nutritonTarget.value = self.userInfo?.fat ?? "0%"
        nutritonTarget.type = HMTargetFillType.fatPer
        let popupVC = HMPopUpViewController(contentController: nutritonTarget, position: .bottom(0), popupWidth: HMSystemInfo.screenWidth, popupHeight: HMSystemInfo.screenHeight)
        popupVC.backgroundAlpha = 0.3
        popupVC.cornerRadius = 0
        popupVC.shadowEnabled = false
        present(popupVC, animated: true, completion: nil)
    }
}

extension HMNutritionGoalVC: HMNutritionGoal002Delegate {
    func tapToAddFavouriteFood3() {
        HMNutritionVC.push(prepare: { vc in
            vc.type = .favorite
            vc.targetEntity = self.foodList?.target
        })
    }
    
    func tapToAddFood2() {
        HMNutritionVC.push(prepare: { vc in
            vc.type = .unfavorite
            vc.targetEntity = self.foodList?.target
        })
    }
}

//extension HMNutritionGoalVC: HMNutritionGoal003Delegate {
//    func tapToAddFood3() {
//        HMNutritionVC.push(prepare: { vc in
//            vc.type = .favorite
//            vc.targetEntity = self.foodList?.target
//        })
//    }
//}

extension HMNutritionGoalVC: HMNutritionGoal004Delegate {
    func tapToEdit004() {
        let nutritonTarget = HMNutritonTargetActionLevelVC.create()
        guard let listTarget = self.foodList?.level_action else { return }
        nutritonTarget.listTarget.accept(listTarget)
        nutritonTarget.targetValue = self.findEntityWithId(id: self.foodList?.target?.id_level ?? "1", withArray: listTarget)
        let popupVC = HMPopUpViewController(contentController: nutritonTarget, position: .bottom(0), popupWidth: HMSystemInfo.screenWidth, popupHeight: HMSystemInfo.screenHeight)
        popupVC.backgroundAlpha = 0.3
        popupVC.cornerRadius = 0
        popupVC.shadowEnabled = false
        present(popupVC, animated: true, completion: nil)
    }
}

extension HMNutritionGoalVC: HMNutritionGoal005Delegate {
    func tapToEdit005() {
        print("///////////// Tap To Edit 5")
    }
}

