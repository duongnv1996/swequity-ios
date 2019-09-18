//
//  HMAddProgramVC.swift
//  SwequityVN
//
//  Created by NamNH-D1 on 7/26/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import JTAppleCalendar

protocol HMAddProgramDelegate: class {
    func didAddProgram(programId: Int)
}

class HMAddProgramVC: HMBaseCalendarVC {

    // MARK: - Outlets
    
    // MARK: - Varibales
    weak var delegate: HMAddProgramDelegate?
    var type : HMCalendarType?
    var programId : String?
    
    var firstTimeStartDate: Date?
    var firstTimeEndDate: Date?
    private var startDate: Date?
    private var endDate : Date?
    private var dateToDeselect : Date?
    
    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Setup views
    override func setupView() {
        super.setupView()
        
        setupCalendar()
    }
    
    override func setupCalendar() {
        super.setupCalendar()
        
        calendarView.allowsRangedSelection = true
        
        if let startDate = firstTimeStartDate,
            let endDate = firstTimeEndDate {
            calendarView.scrollToDate(startDate, animateScroll: false)
            calendarView.selectDates([startDate])
            calendarView.selectDates([endDate])
        }
    }
    
    // MARK: - Management data
    
    // MARK: - Actions
    @IBAction func invokeCloseButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func invokeContinueButton(_ sender: UIButton) {
        guard let startDateStr = dateToDeselect?.stringBy(format: Date.dateFormatS),
            let endDateStr = endDate?.stringBy(format: Date.dateFormatS) else {
                UIAlertController.showQuickSystemAlert(message: "Cần chọn ngày bắt đầu và kết thúc !", cancelButtonTitle: "Đồng ý")
                return
        }
        
        if type == .add {
            HMAddProgramAPI(title: "", startDate: startDateStr, endDate: endDateStr).execute(target: self, success: {[weak self] (response) in
                guard let sSelf = self else { return }
                switch response.errorId {
                case HMErrorCode.success.rawValue:
                    sSelf.delegate?.didAddProgram(programId: response.programId)
                    sSelf.dismiss(animated: true, completion: nil)
                case HMErrorCode.error.rawValue:
                    UIAlertController.showQuickSystemAlert(message: response.message, cancelButtonTitle: "Đồng ý")
                default:
                    break
                }
                }, failure: { (error) in
                    UIAlertController.showQuickSystemAlert(message: error.message, cancelButtonTitle: "Đồng ý")
            })
        } else {
            HMUpdateTrainingProgramAPI(programId: self.programId ?? "", title: "", dateStart: startDateStr, dateEnd: endDateStr).execute(target: self, success: { (response) in
                switch response.errorId {
                case HMErrorCode.success.rawValue:
                    self.delegate?.didAddProgram(programId: Int(self.programId ?? "0") ?? 0)
                    self.dismiss(animated: true, completion: nil)
                case HMErrorCode.error.rawValue:
                    UIAlertController.showQuickSystemAlert(message: response.message, cancelButtonTitle: "Đồng ý")
                default:
                    break
                }
            }, failure: { (error) in
                UIAlertController.showQuickSystemAlert(message: error.message, cancelButtonTitle: "Đồng ý")
            })
        }
    }
    // MARK: - Private method
    // MARK: - Override method
    override func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        guard let cell = cell as? HMCalendarCell else { return }
        
        if startDate != nil {
            if date < startDate! {
                endDate = startDate
                dateToDeselect = date
                startDate = nil
            } else {
                endDate = date
                dateToDeselect = startDate
                startDate = nil
            }
            calendar.selectDates(from: dateToDeselect!, to: endDate!, triggerSelectionDelegate: false, keepSelectionIfMultiSelectionAllowed: true)
            
        } else {
            if endDate != nil {
                calendarView.deselectDates(from: dateToDeselect!, to: endDate!, triggerSelectionDelegate: false)
                endDate = nil
            }
            startDate = date
        }
        
        cell.handleSelected(cellState: cellState)
    }
    
    override func calendar(_ calendar: JTACMonthView, didDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        guard let cell = cell as? HMCalendarCell else { return }
        if endDate != nil {
            calendarView.deselectDates(from: dateToDeselect!, to: endDate!, triggerSelectionDelegate: false)
            endDate = nil
            startDate = nil
        }
        cell.handleSelected(cellState: cellState)
    }
}
