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

class HMNutritionVC: HMBaseVC {

    // MARK: - Outlets
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Variables
    private let disposeBag = DisposeBag()
    private let listFoods: BehaviorRelay<[String]> = BehaviorRelay(value: [])
    
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
        
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.registerNibCellFor(type: HMNutritionCell.self)
        
        listFoods.bind(to: tableView.rx.items(cellIdentifier: "HMNutritionCell", cellType: HMNutritionCell.self)) { row, model, cell in
            }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(String.self).subscribe(onNext: {task in
            // TODO : Open Task detail screen
        }).disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.tableView.deselectRow(at: indexPath, animated: true)
            }).disposed(by: disposeBag)
    }
    
    // MARK: - Management Datas
    private func fetchData() {
        listFoods.accept(["string"])
    }

}
