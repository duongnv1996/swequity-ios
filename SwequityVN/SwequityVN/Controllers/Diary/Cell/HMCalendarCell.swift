//
//  HMCalendarCell.swift
//  ProjectBase
//
//  Created by NamNH-D1 on 7/26/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import JTAppleCalendar

class HMCalendarCell: JTACDayCell {

    @IBOutlet weak var todayView: UIView!
    @IBOutlet weak var selectedView: UIView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var eventView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func handleCellColor(cellState: CellState) {
        if cellState.dateBelongsTo == .thisMonth {
            dayLabel.textColor = .black
        } else {
            dayLabel.textColor = .gray
        }
        
        let currentDay = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MM yyyy"
        
        let currentDateString = dateFormatter.string(from: currentDay)
        let cellStateDateString = dateFormatter.string(from: cellState.date)
        
        if  currentDateString == cellStateDateString {
            todayView.isHidden = false
            dayLabel.textColor = .white
        } else {
            todayView.isHidden = true
            todayView.cornerRadius = 0
        }
    }
    
    func handleSelected(cellState: CellState) {
        selectedView.isHidden = !cellState.isSelected
        
        if #available(iOS 11.0, *) {
            switch cellState.selectedPosition() {
            case .left:
                selectedView.layer.cornerRadius = selectedView.frame.size.height/2
                selectedView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
            case .middle:
                selectedView.layer.cornerRadius = 0
                selectedView.layer.maskedCorners = []
            case .right:
                selectedView.layer.cornerRadius = selectedView.frame.size.height/2
                selectedView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
            case .full:
                selectedView.layer.cornerRadius = selectedView.frame.size.height/2
                selectedView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
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
            let path = UIBezierPath(roundedRect: selectedView.bounds, byRoundingCorners: cornerMask, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            selectedView.layer.mask = mask
        }
    }

}
