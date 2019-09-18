//
//  HMPickupSideVC.swift
//  SwequityVN
//
//  Created by NamNH-D1 on 8/23/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit

class HMPickupSideVC: HMBaseVC {

    @IBOutlet weak var frontCheckmark: UIImageView!
    @IBOutlet weak var sideCheckMark: UIImageView!
    @IBOutlet weak var backCheckMark: UIImageView!
    
    var didUpdateImage: ((_ imageType: HMImageType) -> Void)?
    private var imageType: HMImageType?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func setupView() {
        super.setupView()
        
        frontCheckmark.isHidden = true
        sideCheckMark.isHidden = true
        backCheckMark.isHidden = true
    }
    
    @IBAction func didTapCloseButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func invokePickupSideButton(_ sender: UIButton) {
        imageType = HMImageType(rawValue: "\(sender.tag)")
        
        frontCheckmark.isHidden = true
        sideCheckMark.isHidden = true
        backCheckMark.isHidden = true
        switch imageType {
        case .front?:
            frontCheckmark.isHidden = false
        case .side?:
            sideCheckMark.isHidden = false
        case .back?:
            backCheckMark.isHidden = false
        default:
            frontCheckmark.isHidden = false
        }
    }
    
    
    @IBAction func invokeUpdateButton(_ sender: UIButton) {
        didUpdateImage?(imageType ?? .front)
    }
}
