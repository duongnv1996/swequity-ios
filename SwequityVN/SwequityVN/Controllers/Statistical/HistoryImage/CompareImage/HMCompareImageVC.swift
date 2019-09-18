//
//  HMComparaImageVC.swift
//  SwequityVN
//
//  Created by RTC-HN360 on 7/31/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import Kingfisher

class HMCompareImageVC: HMBaseVC {
    
    // MARK: - Outlets
    @IBOutlet weak var rightImage: UIImageView!
    @IBOutlet weak var leftImage: UIImageView!
    @IBOutlet weak var rightDateLB: UILabel!
    @IBOutlet weak var leftDateLB: UILabel!
    @IBOutlet weak var rightScrollView: UIScrollView!
    @IBOutlet weak var leftScrollView: UIScrollView!
    
    var rightImg: String?
    var leftImg: String?
    var rightDate: String?
    var leftDate: String?
    
    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        rightScrollView.minimumZoomScale = 1.0
        rightScrollView.maximumZoomScale = 6.0
        rightScrollView.delegate = self
        leftScrollView.minimumZoomScale = 1.0
        leftScrollView.maximumZoomScale = 6.0
        leftScrollView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        UINavigationController.attemptRotationToDeviceOrientation()
    }
    
    override func setupView() {
        super.setupView()
        
        if let rightImg = rightImg,
            let rightImageURL = URL(string: rightImg) {
            rightImage.kf.setImage(with: rightImageURL)
        }
        
        if let leftImg = leftImg,
            let leftImageURL = URL(string: leftImg) {
            leftImage.kf.setImage(with: leftImageURL)
        }
        
        rightDateLB.text = rightDate
        leftDateLB.text = leftDate
    }

    @IBAction func didTapCloseButton(_ sender: UIButton) {
    }
    
    // MARK: - Override method
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
}

extension HMCompareImageVC: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        if scrollView == self.rightScrollView {
            return self.rightImage
        } else {
            return self.leftImage
        }
    }
}
