//
//  HMHistoryImageView.swift
//  SwequityVN
//
//  Created by Tung QT on 8/9/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit

protocol HMHistoryImageViewDelegate: NSObjectProtocol {
    func tapToLeft()
    func tapToMiddle()
    func tapToRight()
}

enum TypeSelectHMHistoryImageVC {
    case left
    case middle
    case right
}

class HMHistoryImageView: UICollectionReusableView {

    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var middleLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    private let colorUnselect = UIColor(red: 159.0 / 255.0, green: 167.0 / 255.0, blue: 179.0 / 255.0, alpha: 1.0)
    private let fontSizeUnselect = UIFont(name: "OpenSans", size: 12.0)!
    private let fontSizeSelect = UIFont(name: "OpenSans", size: 15.0)!

    weak var delegate: HMHistoryImageViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(tapLeft))
        leftLabel.addGestureRecognizer(tap1)
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(tapMiddle))
        middleLabel.addGestureRecognizer(tap2)
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(tapRight))
        rightLabel.addGestureRecognizer(tap3)
        updateUI(type: .left)
    }
    
    func updateUI(type: TypeSelectHMHistoryImageVC) {
        setUI(label: leftLabel, select: false)
        setUI(label: middleLabel, select: false)
        setUI(label: rightLabel, select: false)
        switch type {
        case .left:
            setUI(label: leftLabel, select: true)
        case .middle:
            setUI(label: middleLabel, select: true)
        case .right:
            setUI(label: rightLabel, select: true)
        }
    }
    
    func setUI(label: UILabel, select: Bool) {
        label.textColor = select ? .black : colorUnselect
        label.font = select ? fontSizeSelect : fontSizeUnselect
    }
    
    @objc
    func tapLeft(sender:UITapGestureRecognizer) {
        updateUI(type: .left)
        delegate?.tapToLeft()
    }
    
    @objc
    func tapMiddle(sender:UITapGestureRecognizer) {
        updateUI(type: .middle)
        delegate?.tapToMiddle()
    }
    
    @objc
    func tapRight(sender:UITapGestureRecognizer) {
        updateUI(type: .right)
        delegate?.tapToRight()
    }
    
}
