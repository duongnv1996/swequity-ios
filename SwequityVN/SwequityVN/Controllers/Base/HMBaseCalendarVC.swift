//
//  HMBaseCalendarVC.swift
//  SwequityVN
//
//  Created by NamNH-D1 on 7/26/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import JTAppleCalendar

class HMBaseCalendarVC: HMBaseVC {

    // MARK: - Outlets
    @IBOutlet weak var calendarView: JTACMonthView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var weekViewStack: UIStackView!
    
    // MARK: - Variables
    private let df = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func setupView() {
        super.setupView()
        
        setupCalendar()
    }

    private func setupCalendar() {
        calendarView.visibleDates() { visibleDates in
            self.setupMonthLabel(date: Date())
        }
        calendarView.ibCalendarDelegate = self
        calendarView.ibCalendarDataSource = self
        calendarView.scrollToDate(Date())
        calendarView.allowsMultipleSelection = true
        calendarView.registerNibCellFor(type: HMCalendarCell.self)
    }

    private func setupMonthLabel(date: Date) {
        df.dateFormat = "MMMM, yyyy"
        monthLabel.text = df.string(from: date)
    }
    
    private func handleConfiguration(indexPath: IndexPath, cellState: CellState) {
        guard let cell = calendarView.cellForItem(at: indexPath) as? HMCalendarCell else { return}
        handleCellColor(cell: cell, cellState: cellState)
        handleCellSelection(cell: cell, cellState: cellState)
    }
    
    private func handleCellColor(cell: HMCalendarCell, cellState: CellState) {
        if cellState.dateBelongsTo == .thisMonth {
            cell.dayLabel.textColor = .black
        } else {
            cell.dayLabel.textColor = .gray
        }
        
        let currentDay = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MM yyyy"
        
        let currentDateString = dateFormatter.string(from: currentDay)
        let cellStateDateString = dateFormatter.string(from: cellState.date)
        
        if  currentDateString == cellStateDateString {
            cell.todayView.isHidden = false
            cell.todayView.cornerRadius = cell.todayView.frame.size.width/2
            cell.dayLabel.textColor = .white
        } else {
            cell.todayView.isHidden = true
            cell.todayView.cornerRadius = 0
        }
    }
    
    private func handleCellSelection(cell: HMCalendarCell, cellState: CellState) {
        cell.selectedView.isHidden = !cellState.isSelected
        
        if #available(iOS 11.0, *) {
            switch cellState.selectedPosition() {
            case .left:
                cell.selectedView.layer.cornerRadius = cell.selectedView.frame.size.height/2
                cell.selectedView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
            case .middle:
                cell.selectedView.layer.cornerRadius = 0
                cell.selectedView.layer.maskedCorners = []
            case .right:
                cell.selectedView.layer.cornerRadius = cell.selectedView.frame.size.height/2
                cell.selectedView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
            case .full:
                cell.selectedView.layer.cornerRadius = cell.selectedView.frame.size.height/2
                cell.selectedView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
            default: break
            }
        } else {
            var corners: [CACornerMask] = []
            var cornerRadius: CGFloat = 0.0
            switch cellState.selectedPosition() {
            case .left:
                cornerRadius = 20.0
                corners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
            case .middle:
                cornerRadius = 0.0
                corners = []
            case .right:
                cornerRadius = 20.0
                corners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
            case .full:
                cornerRadius = 20.0
                corners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
            default: break
            }
            
            var cornerMask = UIRectCorner()
            if(corners.contains(.layerMinXMinYCorner)) {
                cornerMask.insert(.topLeft)
            }
            if(corners.contains(.layerMaxXMinYCorner)){
                cornerMask.insert(.topRight)
            }
            if(corners.contains(.layerMinXMaxYCorner)){
                cornerMask.insert(.bottomLeft)
            }
            if(corners.contains(.layerMaxXMaxYCorner)){
                cornerMask.insert(.bottomRight)
            }
            let path = UIBezierPath(roundedRect: cell.selectedView.bounds, byRoundingCorners: cornerMask, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            cell.selectedView.layer.mask = mask
        }
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
    
}

extension HMBaseCalendarVC: JTACMonthViewDelegate, JTACMonthViewDataSource {
    
    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        guard let cell = cell as? HMCalendarCell else { return }
        handleCellColor(cell: cell, cellState: cellState)
        handleCellSelection(cell: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        guard let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "HMCalendarCell", for: indexPath) as? HMCalendarCell else { return JTACDayCell() }
        cell.dayLabel.text = cellState.text
        self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        return cell
    }
    
    func calendar(_ calendar: JTACMonthView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupMonthLabel(date: visibleDates.monthDates.first!.date)
    }
    
    func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        handleConfiguration(indexPath: indexPath, cellState: cellState)
        
        if indexPath.row != 0 {
            let leftIndexPath = IndexPath(row: indexPath.row - 1, section: indexPath.section)
            let previousDate = Calendar.current.date(byAdding: .day, value: -1, to: date)
            let lefCellState = calendar.cellStatus(for: previousDate!)
            handleConfiguration(indexPath: leftIndexPath, cellState: lefCellState!)
        }
        if indexPath.row != (calendarView.numberOfItems(inSection: indexPath.section) - 1) {
            let nextDate = Calendar.current.date(byAdding: .day, value: 1, to: date)
            let rightIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
            let rightCellState = calendar.cellStatus(for: nextDate!)
            handleConfiguration(indexPath: rightIndexPath, cellState: rightCellState!)
        }
    }
    
    func calendar(_ calendar: JTACMonthView, didDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        handleConfiguration(indexPath: indexPath, cellState: cellState)
        
        if indexPath.row != 0 {
            let leftIndexPath = IndexPath(row: indexPath.row - 1, section: indexPath.section)
            let previousDate = Calendar.current.date(byAdding: .day, value: -1, to: date)
            let lefCellState = calendar.cellStatus(for: previousDate!)
            handleConfiguration(indexPath: leftIndexPath, cellState: lefCellState!)
        }
        if indexPath.row != (calendarView.numberOfItems(inSection: indexPath.section) - 1) {
            let nextDate = Calendar.current.date(byAdding: .day, value: 1, to: date)
            let rightIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
            let rightCellState = calendar.cellStatus(for: nextDate!)
            handleConfiguration(indexPath: rightIndexPath, cellState: rightCellState!)
        }
    }
    
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        let df = DateFormatter()
        df.dateFormat = "yyyy MM dd"
        
        let startDate = Date().set(year: 2017, month: 1, day: 1)!
        let endDate = Date().set(year: 2100, month: 12, day: 31)!
        
        let parameter = ConfigurationParameters(startDate: startDate,
                                                endDate: endDate,
                                                numberOfRows: 6,
                                                generateInDates: .forAllMonths,
                                                generateOutDates: .tillEndOfGrid,
                                                firstDayOfWeek: .sunday)
        return parameter
    }
}
