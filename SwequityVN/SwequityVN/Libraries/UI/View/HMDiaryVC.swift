//
//  HMDiaryVC.swift
//  SwequityVN
//
//  Created by NamNH-D1 on 7/24/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import JTAppleCalendar
import RxSwift
import RxCocoa

class HMDiaryVC: HMBaseCalendarVC {
    
    // MARK: - Outlets
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Variables
    private let disposeBag = DisposeBag()
    private let listTasks: BehaviorRelay<[String]> = BehaviorRelay(value: [])
    
    // MARK: - Outlets
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        fetchData()
    }
    
    override func setupView() {
        super.setupView()
        titleScreen = "Kế hoạch của tôi"
        
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.registerNibCellFor(type: HMTaskCell.self)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        
        listTasks.bind(to: tableView.rx.items(cellIdentifier: "HMTaskCell", cellType: HMTaskCell.self)) { row, model, cell in
            }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(String.self).subscribe(onNext: {task in
            // TODO : Open Task detail screen
        }).disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.tableView.deselectRow(at: indexPath, animated: true)
            }).disposed(by: disposeBag)
    }
    
    // MARK: - Management Data
    private func fetchData() {
        listTasks.accept(["test", "test", "test", "test", "test"])
    }
    
    // MARK: - Actions
    @IBAction func invokeAddTaskButton(_ sender: UIButton) {
        let addNewTaskVC = HMAddNewTaskVC.create()
        
        let popupVC = HMPopUpViewController(contentController: addNewTaskVC, position: .bottom(0), popupWidth: HMSystemInfo.screenWidth, popupHeight: HMSystemInfo.screenHeight)
        popupVC.backgroundAlpha = 0.3
        popupVC.cornerRadius = 0
        popupVC.shadowEnabled = false
        present(popupVC, animated: true, completion: nil)
    }
}
