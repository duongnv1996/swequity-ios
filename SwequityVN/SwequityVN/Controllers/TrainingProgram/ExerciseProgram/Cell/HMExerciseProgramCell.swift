//
//  HMExerciseProgramCell.swift
//  SwequityVN
//
//  Created by RTC-HN360 on 8/1/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import Kingfisher

protocol HMExerciseProgramCellDelegate: class {
    func didSelectLinkedButton(at cell: HMExerciseProgramCell, ischecked: Bool)
    func didSelectDetailButton(at cell: HMExerciseProgramCell)
    func swipeToDelete(at cell: HMExerciseProgramCell)
}

class HMExerciseProgramCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var linkedView: HMShadowView!
    @IBOutlet var linkedViewToTop: NSLayoutConstraint!
    @IBOutlet var linkedViewToTopEqualTen: NSLayoutConstraint!
    @IBOutlet var linkedViewToBottom: NSLayoutConstraint!
    @IBOutlet var linkedViewToBottomEqualTen: NSLayoutConstraint!
    @IBOutlet weak var linkedButton: HMCheckBoxButton!
    @IBOutlet weak var detailView: HMShadowView!
    @IBOutlet weak var exeImageView: UIImageView!
    @IBOutlet weak var exersiceTimeLabel: UILabel!
    @IBOutlet weak var setLabel: UILabel!
    @IBOutlet weak var repLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    // MARK: - Variables
    weak var delegate: HMExerciseProgramCellDelegate?
    private var panGesture: UIPanGestureRecognizer!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        panGesture = UIPanGestureRecognizer(target: self, action: #selector(swipeToDelete))
//        panGesture.delegate = self
//        detailView.addGestureRecognizer(panGesture)
    }
    
    private func setData(dto: HMExerciseInSessionDetailEntity) {
        if let url = dto.img.url {
            let imageViewResource = ImageResource(downloadURL: url, cacheKey: "\(url)-imageview")
            exeImageView.kf.setImage(with: imageViewResource)
        }
        exersiceTimeLabel.text = dto.name
        setLabel.text = "Số hiệp: \(dto.sets)"
        repLabel.text = "Số lần tập: \(dto.reps)"
        timeLabel.text = dto.break_time
    }

    func setContent(at row: Int, entity: HMExerciseInSessionDetailEntity, isDisplayLinked: Bool, isDisplayLinkedView: Bool, isDisplayLinkedButton: Bool) {
//        linkedView.isHidden = !entity[0]
        setData(dto: entity)
        self.linkedView.isHidden = !isDisplayLinkedView
        if isDisplayLinked {
            if (row == 0) {
                linkedButton.isHidden = true
            } else {
                linkedButton.isHidden = false
            }
        } else {
            linkedButton.isHidden = true
        }
        self.linkedButton.isChecked = isDisplayLinkedButton
        layer.zPosition = CGFloat(row)
//        if entity[1] {
//            NSLayoutConstraint.activate([linkedViewToTopEqualTen])
//            NSLayoutConstraint.deactivate([linkedViewToTop])
//        }
//        else {
//            NSLayoutConstraint.activate([linkedViewToTop])
//            NSLayoutConstraint.deactivate([linkedViewToTopEqualTen])
//        }
//        
//        if entity[2] {
//            NSLayoutConstraint.activate([linkedViewToBottomEqualTen])
//            NSLayoutConstraint.deactivate([linkedViewToBottom])
//        } else {
//            NSLayoutConstraint.activate([linkedViewToBottom])
//            NSLayoutConstraint.deactivate([linkedViewToBottomEqualTen])
//        }
    }
    
    @IBAction func invokeDetailButton(_ sender: UIButton) {
        delegate?.didSelectDetailButton(at: self)
    }
    
    @IBAction func invokeLinkedButton(_ sender: HMCheckBoxButton) {
        delegate?.didSelectLinkedButton(at: self, ischecked: sender.isChecked)
    }
    
//    @objc func swipeToDelete(_ recognizer: UIPanGestureRecognizer) {
//        let detailFrame = detailView.frame
//        let p: CGPoint = recognizer.translation(in: self)
//        switch recognizer.state {
//        case .began:
//            break
//        case .changed:
//            if recognizer.velocity(in: self).x < 0 {
//                detailView.frame = CGRect(x: p.x, y: detailFrame.origin.y, width: detailFrame.size.width, height: detailFrame.size.height)
//            }
//        case .cancelled:
//            if recognizer.velocity(in: self).x < 0 {
//                UIView.animate(withDuration: 0.2, animations: {
//                    self.detailView.frame = CGRect(x: 20, y: detailFrame.origin.y, width: detailFrame.size.width, height: detailFrame.size.height)
//                })
//            }
//        case .ended:
//            if recognizer.velocity(in: self).x < -500 {
//                delegate?.swipeToDelete(at: self)
//            } else {
//                UIView.animate(withDuration: 0.2, animations: {
//                    self.detailView.frame = CGRect(x: 20, y: detailFrame.origin.y, width: detailFrame.size.width, height: detailFrame.size.height)
//                })
//            }
//        case .failed:
//            if recognizer.velocity(in: self).x < 0 {
//                UIView.animate(withDuration: 0.2, animations: {
//                    self.detailView.frame = CGRect(x: 20, y: detailFrame.origin.y, width: detailFrame.size.width, height: detailFrame.size.height)
//                })
//            }
//        default:
//            break
//        }
//    }
}
