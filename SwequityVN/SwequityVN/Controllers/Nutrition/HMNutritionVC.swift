//
//  HMNutritionVC.swift
//  SwequityVN
//
//  Created by Nguyễn Nam on 7/26/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

struct FoodValue: Equatable {
    let id: String
    var number: String
}

class HMNutritionVC: HMBaseVC {

    // MARK: - Outlets
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet weak var oldCaloLabel: UILabel!
    @IBOutlet weak var newCaloLabel: UILabel!
    @IBOutlet weak var oldCaloFatLabel: UILabel!
    @IBOutlet weak var newCaloFatLabel: UILabel!
    @IBOutlet weak var oldCaloProLabel: UILabel!
    @IBOutlet weak var newCaloProLabel: UILabel!
    @IBOutlet weak var oldCaloGluLabel: UILabel!
    @IBOutlet weak var newCaloGluLabel: UILabel!
    // MARK: - Variables
    private let disposeBag = DisposeBag()
    private let listFoods: BehaviorRelay<[HMFoodDetailEntity]> = BehaviorRelay(value: [])
    
    var targetEntity:HMTargetEntity?
    var type:HMFavouriteType = HMFavouriteType.unfavorite
    private var listFoodCal:[FoodValue] = []
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        let rightBarButton: UIBarButtonItem = UIBarButtonItem(title: "Lưu", style: .done, target: self, action: #selector(saveData))
        self.navigationItem.rightBarButtonItem = rightBarButton
        self.oldCaloLabel.text = String(Int(self.roundInfo(value: (Float(self.targetEntity?.total ?? "0") ?? 0))))
        self.oldCaloFatLabel.text = String(Int(self.roundInfo(value: (Float(self.targetEntity?.fat ?? "0") ?? 0))))
        self.oldCaloProLabel.text = String(Int(self.roundInfo(value: (Float(self.targetEntity?.protein ?? "0") ?? 0))))
        self.oldCaloGluLabel.text = String(Int(self.roundInfo(value: (Float(self.targetEntity?.carb ?? "0") ?? 0))))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchData()
    }
    
    // MARK: - Setup views
    override func setupView() {
        super.setupView()
        
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.registerNibCellFor(type: HMNutritionCell.self)
        
        listFoods.bind(to: tableView.rx.items(cellIdentifier: "HMNutritionCell", cellType: HMNutritionCell.self)) { row, model, cell in
            cell.setContentWithEntity(food: model, withType: self.type)
            cell.delegate = self
            }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(String.self).subscribe(onNext: {task in
            // TODO : Open Task detail screen
        }).disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.tableView.deselectRow(at: indexPath, animated: true)
            }).disposed(by: disposeBag)
    }
    
    @objc func saveData()  {
        let listdata = listFoodCal.compactMap({ return ["id": $0.id,
                                                        "number": $0.number]})
        if let theJSONData = try?  JSONSerialization.data(
            withJSONObject: listdata),
            
            let theJSONText = String(data: theJSONData,
                                     encoding: .utf8) {
            
            print(theJSONText)
            
            HMCalculateCaloAPI(idFood: theJSONText).execute(target: self, success: { (response) in
                self.pop()
            }) { (error) in
                
            }
        }
    }
    
    // MARK: - Management Datas
    private func fetchData() {
        HMFoodListAPI().execute(target: self, success: {[weak self] (response) in
            guard let sSelf = self else { return }
            switch response.errorId {
            case HMErrorCode.success.rawValue:
                let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
                appDelegate?.foodList = response.foodList
                let foodListWithType = sSelf.type == .favorite ? response.foodList?.food_favourite : response.foodList?.food
                sSelf.listFoods.accept(foodListWithType ?? [])
                sSelf.listFoodCal = foodListWithType?.compactMap({
                    return FoodValue(id: $0.id, number: "0")
                }) ?? []
                break
            case HMErrorCode.error.rawValue:
                UIAlertController.showQuickSystemAlert(message: response.message, cancelButtonTitle: "Đồng ý")
            default:
                break
            }
        }) { (error) in
            
        }
    }
    
    func calculateInfo(foodId: String, value: String, oldValue: String) {
        for entity in self.listFoods.value {
            if foodId == entity.id {
                if var valueFood = Float(value), var valueOldFood = Float(oldValue) {
                    valueFood = self.roundInfo(value: valueFood)
                    valueOldFood = self.roundInfo(value: valueOldFood)
                    
                    var fat = (Float(entity.fat) ?? 0) * (valueFood - valueOldFood)
                    fat = self.roundInfo(value: fat)
                    var pro = (Float(entity.protein) ?? 0) * (valueFood - valueOldFood)
                    pro = self.roundInfo(value: pro)
                    var glu = (Float(entity.cabs) ?? 0) * (valueFood - valueOldFood)
                    glu = self.roundInfo(value: glu)
                    var fatLabel = Float(self.newCaloFatLabel.text ?? "0") ?? 0
                    fatLabel = self.roundInfo(value: fatLabel)
                    var proLabel = Float(self.newCaloFatLabel.text ?? "0") ?? 0
                    proLabel = self.roundInfo(value: proLabel)
                    var gluLabel = Float(self.newCaloFatLabel.text ?? "0") ?? 0
                    gluLabel = self.roundInfo(value: gluLabel)
                    var totalLabe = fatLabel + proLabel + gluLabel
                    totalLabe = self.roundInfo(value: totalLabe)
                    
                    self.newCaloFatLabel.text = (fat + fatLabel) > 0 ? String(Int(self.roundInfo(value: fat + fatLabel))) : "0"
                    self.newCaloProLabel.text = (pro + proLabel) > 0 ? String(Int(self.roundInfo(value: pro + proLabel))) : "0"
                    self.newCaloGluLabel.text = (glu + gluLabel) > 0 ? String(Int(self.roundInfo(value: glu + gluLabel))) : "0"
                    self.newCaloLabel.text = (fat + pro + glu + totalLabe) > 0 ? String(Int(self.roundInfo(value: (fat + pro + glu + totalLabe)))) : "0"
                }
            }
        }
    }
    
    func roundInfo(value: Float) -> Float {
        return round(value * pow(10, 0))/pow(10, 0)
    }

}

extension HMNutritionVC: HMNutritionCellDelegate {
    func didChangeValue(foodId: String, value: String) {
        if let food = listFoodCal.first(where: { $0.id == foodId} ) {
            let newFood = FoodValue(id: food.id, number: value)
            if let index = listFoodCal.firstIndex(of: food) {
                calculateInfo(foodId: foodId, value: value, oldValue: listFoodCal[index].number)
                listFoodCal[index] = newFood
            }
        }
    }
    
    func didTapFavoriteButton(idFood: String, isFavourited: Bool) {
        HMFavouriteFoodAPI.init(idFood: idFood, type: isFavourited == true ? "1" : "2").execute(target: self, success: { (response) in
            self.fetchData()
        }, failure: { (error) in
            
        })
    }
}
