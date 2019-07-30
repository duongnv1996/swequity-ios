//
//  HMLoginServices.swift
//  ProjectBase
//
//  Created by NamNH-D1 on 4/9/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit

protocol HMLoginServices {
    init(target viewController: UIViewController & HMLoginServicesDelegate)
    func doLogin()
}

protocol HMLoginServicesDelegate: class {
    func didLogin(profile: HMUserProfileEntity?)
}
