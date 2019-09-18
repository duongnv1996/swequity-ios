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
    @IBOutlet var tableHeaderView: UIView!
    
    // MARK: - Variables
    private let disposeBag = DisposeBag()
    private let listTasks: BehaviorRelay<[HMExerciseInSessionDetailEntity]> = BehaviorRelay(value: [])
    
    var dateString:String?
    
    // MARK: - Outlets
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
    }
    
    override func setupView() {
        super.setupView()
        titleScreen = "Kế hoạch của tôi"
        
        setupTableView()
        setupCalendar()
    }
    
    override func setupCalendar() {
        super.setupCalendar()
        
    }
    
    private func setupTableView() {
        tableView.tableHeaderView = tableHeaderView
        tableView.estimatedRowHeight = 200
        tableView.registerNibCellFor(type: HMTaskCell.self)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        tableView
            .rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        listTasks.bind(to: tableView.rx.items(cellIdentifier: "HMTaskCell", cellType: HMTaskCell.self)) { row, model, cell in
            cell.setData(entity: model)
            }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(HMExerciseInSessionDetailEntity.self).subscribe(onNext: {task in
            // TODO : Open Task detail screen
            
        }).disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let sSelf = self else { return }
                sSelf.tableView.deselectRow(at: indexPath, animated: true)
                
                let cell = sSelf.tableView.cellForRow(at: indexPath) as? HMTaskCell
                sSelf.tableView.beginUpdates()
                cell?.updateCollapseUI()
                sSelf.tableView.endUpdates()
            }).disposed(by: disposeBag)
    }
    
    // MARK: - Management Data
    private func fetchData() {
        fetchListProgram()
        self.dateString = Date().stringBy(format: Date.dateFormat)
        fetchExerciseByDate(date: Date())
    }
    
    private func fetchListProgram() {
        HMListProgramAPI().execute(target: self, success: {[weak self] (response) in
            guard let sSelf = self else { return }
            // success
            for program in response.programList {
                let dates = program.session?.compactMap({ session -> Date? in
                    guard let date =  Date.getDateBy(string: session.date_app, format: Date.dateTimeFullFormat) else { return nil }
                    let dc = Date.currentCalendar.dateComponents([.year, .month, .day], from: date)
                    return Date.currentCalendar.date(from: dc)
                })
                
                sSelf.eventDates.append(contentsOf: dates ?? [])
            }
            sSelf.calendarView.reloadData()
        }) { (error) in
            
        }
    }
    
    private func fetchExerciseByDate(date: Date? = nil) {
        if let date = date {
            let dateStr = date.stringBy(format: Date.dateFormat)
            HMExerciseInDateAPI(date: dateStr).showIndicator(false).execute(target: self, success: {[weak self] (response) in
                guard let sSelf = self else { return }
                // success
                switch response.errorId {
                case HMErrorCode.success.rawValue:
                    sSelf.listTasks.accept(response.exList)
                default:
                    sSelf.listTasks.accept([])
                }
                }, failure: { (error) in
                    UIAlertController.showQuickSystemAlert(message: error.message, cancelButtonTitle: "Đồng ý")
            })
        } else {
            listTasks.accept([])
        }
    }
    
    // MARK: - Actions
    @IBAction func invokeAddProgramButton(_ sender: UIButton) {
        if let nav = navigationController {
            HMTrainingProgramVC.push(from: nav.topViewController, animated: true, prepare: { (vc) in
                vc.type = HMCalendarType.update
                vc.dateString = self.dateString
            }, completion: nil)
        }
    }
    
    // MARK: - Override method
    override func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        guard let cell = cell as? HMCalendarCell else { return }
        fetchExerciseByDate(date: date)
        self.dateString = date.stringBy(format: Date.dateFormat)
        cell.handleSelected(cellState: cellState)
    }
    
    override func calendar(_ calendar: JTACMonthView, didDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
            guard let cell = cell as? HMCalendarCell else { return }
            fetchExerciseByDate()
            cell.handleSelected(cellState: cellState)
    }
}

extension HMDiaryVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}
