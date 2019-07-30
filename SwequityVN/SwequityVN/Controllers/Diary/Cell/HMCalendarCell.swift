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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
//    func handleSelected(cellState: CellState) {
//        switch cellState.selectedPosition() {
//        case .left:
//            selectedView.isHidden = true
//            return
//            
//        case .right, .full:
//            selectedView.isHidden = false
//            return
//            
//        case .middle:
//            selectedView.isHidden = true
//            return
//            
//        case .none:
//            selectedView.isHidden = true
//            return
//        }
//    }

}
