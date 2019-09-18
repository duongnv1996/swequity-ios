//
//  HMNotificationTableViewCell.swift
//  Develop
//
//  Created by RTC-HN360 on 7/28/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit

class HMNotificationTableViewCell: UITableViewCell {

    
    @IBOutlet weak var unreadStatusView: HMShadowView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    let notificationEntity: HMNotificationDetailEntity? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    //MARK: Private methods
    func setContentWithEntity(notificationEntity: HMNotificationDetailEntity) {
        let redColor = UIColor(displayP3Red: 208/255, green: 2/255, blue: 27/255, alpha: 1)
        let greyColor = UIColor(displayP3Red: 216/255, green: 216/255, blue: 216/255, alpha: 1)
        self.unreadStatusView.fillColor = notificationEntity.user_read == 1 ? greyColor : redColor
        self.titleLabel.text = notificationEntity.title
        self.contentLabel.text = notificationEntity.content
    }
}
