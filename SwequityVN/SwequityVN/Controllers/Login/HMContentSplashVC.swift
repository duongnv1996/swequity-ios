//
//  HMContentSplashVC.swift
//  Develop
//
//  Created by RTC-HN360 on 7/24/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit

class HMContentSplashVC: HMBaseVC {

    @IBOutlet weak var splashImageView: UIImageView!
    @IBOutlet weak var tittleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    var titleStr: String!
    var content: String!
    var image: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func setupView() {
        super.setupView()
        tittleLabel.text = titleStr
        contentLabel.text = content
        splashImageView.image = UIImage(named: image)
    }
    
}
