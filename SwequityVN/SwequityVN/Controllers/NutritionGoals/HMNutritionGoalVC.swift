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
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchData()
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
        case is HMNutritionGoal003Entity:
            guard let cell = table.reusableCell(type: HMNutritionGoal003Cell.self) else { return UITableViewCell() }
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
        let value1 = HMNutritionGoal001Entity(titleName: "Mục tiêu", subTitle001: "Số cân hiện tại", subTitle002: "Mục tiêu tuần", subTitle003: "Tỉ lệ mỡ", weightCurrent: "65", weightTarget: "66", fatPercent: "12", currentDate: "5/11/2018", targetDate: "12/11/2018")
        let value2 = HMNutritionGoal002Entity(titleName: "Danh sách món ăn", foods: ["Thịt gà", "Thịt bò", "Thịt gà", "Thịt bò", "Thịt bò", "Thịt gà", "Thịt bò", "Thịt bò", "Thịt gà", "Thịt bò", "Thịt bò", "Thịt gà", "Thịt bò"], subTitleName: "Giá trị Calo mong muốn", caloValue: "632")
        let value3 = HMNutritionGoal003Entity(titleName: "Món ưa thích", foods: ["Thịt gà", "Thịt bò", "Thịt gà", "Thịt bò", "Thịt bò", "Thịt gà", "Thịt bò", "Thịt bò", "Thịt gà", "Thịt bò", "Thịt bò", "Thịt gà", "Thịt bò"])
        let value4 = HMNutritionGoal004Entity(titleName: "Mức độ vận động", statusTort: "Thường xuyên vận động")
        let elementFood1 = ElementFood(titleName: "Chất béo", percent: "12", calo: "294")
        let elementFood2 = ElementFood(titleName: "Protein", percent: "24", calo: "558")
        let elementFood3 = ElementFood(titleName: "Tinh bột", percent: "14", calo: "343")
        let elementFood4 = ElementFood(titleName: "Khác", percent: "5", calo: "122")
        let value5 = HMNutritionGoal005Entity(titleName: "Giá trị dinh duỡng mong muốn", caloValue: "1374", elementFoods: [elementFood1, elementFood2,elementFood3,elementFood4])
        lists.accept([value1,value2,value3,value4,value5])
        
//        let sectionValues: [CellModel<AnyObject>] = [
//            CellModel.standard(HMNutritionGoal001Entity(titleName: "Mục tiêu", subTitle001: "Số cân hiện tại", subTitle002: "Mục tiêu tuần", subTitle003: "Tỉ lệ mỡ", weightCurrent: "65", weightTarget: "66", fatPercent: "12", currentDate: "5/11/2018", targetDate: "12/11/2018")),
//            CellModel.standard(HMNutritionGoal002Entity(titleName: "test1", foods: ["test1", "test1"], subTitleName: "test1", caloValue: "test1")),
//        ]
//
//        let section1 = SectionModel(model: "Standard Items", items: sectionValues)
//        sections.accept([section1])
    }
    
}

extension HMNutritionGoalVC: HMNutritionGoal001Delegate {
    func tapToEdit() {
        print("///////////// Tap To Edit")
    }
}

extension HMNutritionGoalVC: HMNutritionGoal002Delegate {
    func tapToAddFood2() {
        print("///////////// Tap To Add Food 2")
    }
}

extension HMNutritionGoalVC: HMNutritionGoal003Delegate {
    func tapToAddFood3() {
        print("///////////// Tap To Add Food 3")
    }
}

extension HMNutritionGoalVC: HMNutritionGoal004Delegate {
    func tapToEdit004() {
        print("///////////// Tap To Edit 4")
    }
}

extension HMNutritionGoalVC: HMNutritionGoal005Delegate {
    func tapToEdit005() {
        print("///////////// Tap To Edit 5")
    }
}

