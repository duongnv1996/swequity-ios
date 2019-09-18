//
//  HMHistoryImageCell.swift
//  SwequityVN
//
//  Created by Tung QT on 8/9/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import Kingfisher

class HMHistoryImageCell: UICollectionViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func setUpData(dto: HMBodyImageDetailEntity) {
        if let imageURL = URL(string: dto.img) {
            imageView.kf.setImage(with: imageURL)
        }
        dateLabel.text = dto.date
    }
    
}
