//
//  HMTutorialImageVC.swift
//  SwequityVN
//
//  Created by RTC-HN360 on 7/28/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit

class HMTutorialImageVC: HMBaseVC {
    
    var didPickedImage: ((_ imageData: Data) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func didTapCloseButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapStartButton(_ sender: UIButton) {
        HMCameraPhotoService.instance.showActionSheetPickupImage {[weak self] (image) in
            guard let sSelf = self,
                let image = image,
                let imageData = HMCameraPhotoService.compressImage(sourceImage: image) else { return }
            sSelf.didPickedImage?(imageData)
            
        }
    }
    
}
