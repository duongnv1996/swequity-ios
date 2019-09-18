//
//  HMPageItemCell.swift
//  SwequityVN
//
//  Created by Nguyễn Nam on 7/27/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import Parchment

struct HMPageItemCellViewModel {
    let image: UIImage?
    let selected: Bool
    let tintColor: UIColor
    let selectedTintColor: UIColor
    let title: String
    
    init(image: UIImage?, selected: Bool, options: PagingOptions, title: String) {
        self.image = image
        self.selected = selected
        self.tintColor = options.textColor
        self.selectedTintColor = options.selectedTextColor
        self.title = title
    }
}

class HMPageItemCell: PagingCell {
    fileprivate lazy var button: UIButton = {
        let button = UIButton(frame: .zero)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        button.isUserInteractionEnabled = false
        return button
    }()
    
    
    fileprivate var viewModel: HMPageItemCellViewModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        contentView.addSubview(button)
        setupConstraints()
    }
    
    override func setPagingItem(_ pagingItem: PagingItem, selected: Bool, options: PagingOptions) {
        
        if let item = pagingItem as? HMPageItem {
            
            let viewModel = HMPageItemCellViewModel(
                image: UIImage(named: item.icon ?? ""),
                selected: selected,
                options: options,
                title: item.title)
            button.setImage(viewModel.image, for: .normal)
            button.setTitle(viewModel.title, for: .normal)
            
            if viewModel.selected {
                button.setTitleColor( UIColor(hex: 0x5E5E5E), for: .normal)
            } else {
                button.setTitleColor( UIColor(hex: 0xD1D1D1), for: .normal)
            }
            self.viewModel = viewModel
            
        }
    }
    
    private func setupConstraints() {
        
        button.translatesAutoresizingMaskIntoConstraints = false
        let buttonLeftContraint = button.getEqualConstraintTo(superView: contentView, attribute: .left)
        let buttonRightContraint = button.getEqualConstraintTo(superView: contentView, attribute: .right)
        let buttonTopContraint = button.getEqualConstraintTo(superView: contentView, attribute: .top)
        let buttonBottomContraint = button.getEqualConstraintTo(superView: contentView, attribute: .bottom)
        contentView.addConstraints([buttonLeftContraint, buttonRightContraint, buttonTopContraint, buttonBottomContraint])
        button.layoutIfNeeded()
    }
}
