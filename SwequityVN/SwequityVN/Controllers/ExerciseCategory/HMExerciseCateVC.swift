//
//  HMExerciseCateVC.swift
//  SwequityVN
//
//  Created by Tung QT on 7/29/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class HMExerciseCateVC: HMBaseVC {
    
    // MARK: - Outlets
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Variables
    var categoryId: String?
    var sessionId: String?
    var type:HMListType = .list
    
    private let disposeBag = DisposeBag()
    private let listTasks: BehaviorRelay<[HMExDetailEntity]> = BehaviorRelay(value: [])

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
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.registerNibCellFor(type: HMExerciseCateCell.self)
        
        listTasks.bind(to: tableView.rx.items(cellIdentifier: "HMExerciseCateCell", cellType: HMExerciseCateCell.self)) { row, model, cell in
            cell.delegate = self
            cell.data = model
            }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(HMExDetailEntity.self).subscribe(onNext: { exercise in
            // TODO : Tap To cell
            if (self.type == .list) {
                HMExeciseDetailVC.push(prepare: { vc in
                    vc.exerciseId = exercise.id
                })
            } else {
                HMAddExerciseInSessionAPI.init(sessionId: self.sessionId ?? "", exId: exercise.id).execute(target: self, success: { (response) in
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
            
        }).disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.tableView.deselectRow(at: indexPath, animated: true)
            }).disposed(by: disposeBag)
    }
    
    // MARK: - Management Data
    private func fetchData() {
        
        if let categoryId = categoryId {
            HMExerciseListAPI(id: categoryId).execute(target: self, success: {[weak self] (response) in
                self?.listTasks.accept(response.exList)
            }) { (error) in
                UIAlertController.showQuickSystemAlert(message: error.message, cancelButtonTitle: "Đồng ý")
            }
        } else {
            HMExerciseFavouriteListAPI().execute(target: self, success: {[weak self] (response) in
                self?.listTasks.accept(response.favouriteList)
            }) { (error) in
                UIAlertController.showQuickSystemAlert(message: error.message, cancelButtonTitle: "Đồng ý")
            }
        }
    }

}

extension HMExerciseCateVC: HMExerciseCateDelegate {
    func tapToFavorite(data: HMExDetailEntity?, type: HMFavouriteType) {
        if let data = data {
            HMExerciseFavouriteAPI(id: data.id, type: type).execute(target: self, success: {[weak self] (response) in
                self?.fetchData()
                }, failure: { (error) in
                    UIAlertController.showQuickSystemAlert(message: error.message, cancelButtonTitle: "Đồng ý")
            })
        }
    }
}
