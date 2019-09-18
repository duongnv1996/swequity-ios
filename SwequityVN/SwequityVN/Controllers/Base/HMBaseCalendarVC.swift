//
//  HMBaseCalendarVC.swift
//  SwequityVN
//
//  Created by NamNH-D1 on 7/26/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import JTAppleCalendar

class HMBaseCalendarVC: HMBaseVC, JTACMonthViewDelegate, JTACMonthViewDataSource {
    // MARK: - Outlets
    @IBOutlet weak var calendarView: JTACMonthView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var weekViewStack: UIStackView!
    
    // MARK: - Variables
    var eventDates: [Date] = []
    private let df = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func setupView() {
        super.setupView()
        
    }

    func setupCalendar() {
        calendarView.visibleDates() { visibleDates in
            self.setupMonthLabel(date: Date())
        }
        calendarView.ibCalendarDelegate = self
        calendarView.ibCalendarDataSource = self
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        calendarView.scrollToDate(Date(), animateScroll: false)
        calendarView.allowsMultipleSelection = false
        calendarView.registerNibCellFor(type: HMCalendarCell.self)
    }

    private func setupMonthLabel(date: Date) {
        df.dateFormat = "MMMM, yyyy"
        monthLabel.text = df.string(from: date)
    }
    
    // MARK: - Management Datas
    
    // MARK: - Actions
    @IBAction func invokePreviousButton(_ sender: UIButton) {
        calendarView.scrollToSegment(.previous)
    }
    
    @IBAction func invokeNextButton(_ sender: UIButton) {
        calendarView.scrollToSegment(.next)
    }
    
    // MARK: - Private method
    
    // MARK: - JTACMonthViewDelegate, JTACMonthViewDataSource
    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        guard let cell = cell as? HMCalendarCell else { return }
        cell.handleCellColor(cellState: cellState)
        cell.handleSelected(cellState: cellState)
    }
    
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        guard let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "HMCalendarCell", for: indexPath) as? HMCalendarCell else { return JTACDayCell() }
        cell.dayLabel.text = cellState.text
        cell.handleCellColor(cellState: cellState)
        cell.handleSelected(cellState: cellState)
        let dateStr = date.stringBy(format: Date.dateTimeFullFormat)
        if let newDate = Date.getDateBy(string: dateStr, format: Date.dateTimeFullFormat) {
            cell.eventView.isHidden = !eventDates.contains(newDate)
        }
        
        return cell
    }
    
    func calendar(_ calendar: JTACMonthView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupMonthLabel(date: visibleDates.monthDates.first!.date)
    }
    
    func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
//        if indexPath.row != 0 {
//            let leftIndexPath = IndexPath(row: indexPath.row - 1, section: indexPath.section)
//            let previousDate = Calendar.current.date(byAdding: .day, value: -1, to: date)
//            let lefCellState = calendar.cellStatus(for: previousDate!)
//            handleConfiguration(indexPath: leftIndexPath, cellState: lefCellState!)
//        }
//        if indexPath.row != (calendarView.numberOfItems(inSection: indexPath.section) - 1) {
//            let nextDate = Calendar.current.date(byAdding: .day, value: 1, to: date)
//            let rightIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
//            let rightCellState = calendar.cellStatus(for: nextDate!)
//            handleConfiguration(indexPath: rightIndexPath, cellState: rightCellState!)
//        }
    }
    
    func calendar(_ calendar: JTACMonthView, didDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
//        if indexPath.row != 0 {
//            let leftIndexPath = IndexPath(row: indexPath.row - 1, section: indexPath.section)
//            let previousDate = Calendar.current.date(byAdding: .day, value: -1, to: date)
//            let lefCellState = calendar.cellStatus(for: previousDate!)
//            handleConfiguration(indexPath: leftIndexPath, cellState: lefCellState!)
//        }
//        if indexPath.row != (calendarView.numberOfItems(inSection: indexPath.section) - 1) {
//            let nextDate = Calendar.current.date(byAdding: .day, value: 1, to: date)
//            let rightIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
//            let rightCellState = calendar.cellStatus(for: nextDate!)
//            handleConfiguration(indexPath: rightIndexPath, cellState: rightCellState!)
//        }
    }
    
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        let df = DateFormatter()
        df.dateFormat = "yyyy MM dd"
        
        let startDate = Date().set(year: 2017, month: 1, day: 1)!
        let endDate = Date().set(year: 2100, month: 12, day: 31)!
        
        let parameter = ConfigurationParameters(startDate: startDate,
                                                endDate: endDate)
        return parameter
    }
}
