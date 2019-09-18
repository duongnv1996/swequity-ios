//
//  HMExerciseFavoriteCell.swift
//  SwequityVN
//
//  Created by Tung QT on 8/2/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import Kingfisher

protocol HMExerciseFavoriteDelegate: NSObjectProtocol {
    func tapToFavorite(data: HMExDetailEntity?, type: HMFavouriteType)
}

class HMExerciseFavoriteCell: UICollectionViewCell {

    @IBOutlet weak var favoriteButton: HMCheckBoxButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    weak var delegate: HMExerciseFavoriteDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var data: HMExDetailEntity? {
        didSet {
            if let data = data {
                setUpData(dto: data)
            }
        }
    }

    private func setUpData(dto: HMExDetailEntity) {
        if let imageURL = URL(string: dto.img) {
            imageView.kf.setImage(with: imageURL)
        }
        titleLabel.text = dto.name

        favoriteButton.isChecked = (dto.is_favourite == .favorite)
        
        favoriteButton.didCheck = {[weak self] isChecked in
            guard let sSelf = self else { return }
            sSelf.delegate?.tapToFavorite(data: dto, type: isChecked ? .favorite : .unfavorite)
        }
    }
}
