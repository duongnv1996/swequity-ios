//
//  HMExerciseCataVC.swift
//  SwequityVN
//
//  Created by Tung QT on 7/30/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class HMExerciseCataVC: HMBaseVC {

    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Variables
    private let disposeBag = DisposeBag()
    private let listTasks: BehaviorRelay<[HMExerciseCataEntity]> = BehaviorRelay(value: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        fetchData()
    }

    // MARK: - Setup views
    override func setupView() {
        super.setupView()
        titleScreen = "Danh mục bài tập"
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.registerNibCellFor(type: HMExerciseCataCell.self)
        
        listTasks.bind(to: tableView.rx.items(cellIdentifier: "HMExerciseCataCell", cellType: HMExerciseCataCell.self)) { row, model, cell in
            cell.data = model
            }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(HMExerciseCataEntity.self).subscribe(onNext: {task in
            // TODO : Tap To cell
            print(task.title)
        }).disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.tableView.deselectRow(at: indexPath, animated: true)
            }).disposed(by: disposeBag)
    }
    
    // MARK: - Management Data
    private func fetchData() {
        let value = HMExerciseCataEntity(image: UIImage(named: "icon_congratulation"), title: "LOWER-BODY POWER", numberExercise: "10")
        let value1 = HMExerciseCataEntity(image: UIImage(named: "icon_congratulation"), title: "CHEST AND ARMS", numberExercise: "6")
        listTasks.accept([value,value1,value,value1,value])
    }
    
}
