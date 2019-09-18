//
//  HMTrainingProgramSlideCell.swift
//  SwequityVN
//
//  Created by NamNH-D1 on 7/26/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
protocol HMTrainingProgramSlideCellDelegate: NSObject {
    func updateProgramName(name: String, startDate: String, endDate: String)
    func didTapDeleteProgramButton()
}
class HMTrainingProgramSlideCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    var isDisplayDeleteButton:Bool = true
    
    weak var delegate: HMTrainingProgramSlideCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var data: HMProgramExDetailEntity? {
        didSet {
            if let data = data {
                setData(dto: data)
            }
        }
    }

    private func setData(dto: HMProgramExDetailEntity?) {
        if let dto = dto {
            self.titleLabel.text = dto.title.isEmpty ? "Thiết lập thời gian tập luyện" : dto.title
            startDateLabel.text = dto.date_start
            endDateLabel.text = dto.date_end
            self.deleteButton.isHidden = !isDisplayDeleteButton
        }
    }
    
    @IBAction func updateProgramName(_ sender: UITextField) {
        self.delegate?.updateProgramName(name: self.titleLabel.text ?? "Thiết lập thời gian tập luyện", startDate: self.startDateLabel.text ?? "01/01/2019", endDate: self.endDateLabel.text ?? "01/01/2019")
    }
    
    @IBAction func didTapDeleteProgramButton(_ sender: UIButton) {
        self.delegate?.didTapDeleteProgramButton()
    }
}
