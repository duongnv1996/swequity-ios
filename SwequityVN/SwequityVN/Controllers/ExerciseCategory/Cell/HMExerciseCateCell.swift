//
//  HMExerciseCateCell.swift
//  SwequityVN
//
//  Created by Tung QT on 7/29/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import Kingfisher

protocol HMExerciseCateDelegate: NSObjectProtocol {
    func tapToFavorite(data: HMExDetailEntity?, type: HMFavouriteType)
}

class HMExerciseCateCell: UITableViewCell {

    @IBOutlet weak var exeImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var favoriteButton: HMCheckBoxButton!
    
    weak var delegate: HMExerciseCateDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // remove separator
        self.separatorInset = UIEdgeInsets(top: 0, left: 1000, bottom: 0, right: 0)
    }
    
    var data: HMExDetailEntity? {
        didSet {
            if let data = data {
                setUpData(dto: data)
            }
        }
    }
    
    func setUpData(dto: HMExDetailEntity) {
        if let url = dto.img.url {
            let imageViewResource = ImageResource(downloadURL: url, cacheKey: "\(url)-imageview")
            exeImageView.kf.setImage(with: imageViewResource)
        }
        titleLabel.text = dto.name
        detailLabel.text = dto.content
        
        favoriteButton.isChecked = (dto.is_fav == .favorite) || (dto.is_favourite == .favorite)
        
        favoriteButton.didCheck = {[weak self] isChecked in
            guard let sSelf = self else { return }
            sSelf.delegate?.tapToFavorite(data: dto, type: isChecked ? .favorite : .unfavorite)
        }
    }
}
