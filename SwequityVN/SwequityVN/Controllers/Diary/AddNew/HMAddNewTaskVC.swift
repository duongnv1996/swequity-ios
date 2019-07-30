//
//  HMAddNewTaskVC.swift
//  SwequityVN
//
//  Created by NamNH-D1 on 7/26/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit

class HMAddNewTaskVC: HMBaseCalendarVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func invokeCloseButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
