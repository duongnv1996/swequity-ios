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
    private let disposeBag = DisposeBag()
    private let listTasks: BehaviorRelay<[HMExerciseCateEntity]> = BehaviorRelay(value: [])

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
            cell.data = model
            }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(HMExerciseCateEntity.self).subscribe(onNext: {task in
            // TODO : Tap To cell
            print(task.detail)
        }).disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.tableView.deselectRow(at: indexPath, animated: true)
            }).disposed(by: disposeBag)
    }
    
    // MARK: - Management Data
    private func fetchData() {
        let value = HMExerciseCateEntity(image: UIImage(named: "icon_premium"), title: "Bài tập nữ cho nhóm cơ", detail: "Giống như động tác gập tạ, bài tập này sẽ tác động vào cơ bắp...")
        listTasks.accept([value,value,value,value,value])
    }

}
