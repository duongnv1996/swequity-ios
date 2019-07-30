//
//  HMMenuVC.swift
//  TimXe
//
//  Created by NamNH-D1 on 5/9/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import SideMenu

class HMMenuVC: HMBaseVC {

    // MARK: - Outlets
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var amount: UILabel!
    
    // MARK: - Constants
    
    // MARK: - Variables
    
    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.isHidden = true
    }
    
    override func setupView() {
        super.setupView()
    }
    
    // MARK: - Data management
    
    // MARK: - Action
    
    // MARK: - Private method
}
