//
//  HMTaskCell.swift
//  SwequityVN
//
//  Created by NamNH-D1 on 7/26/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class HMTaskCell: UITableViewCell {

    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var roundLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var repLabel: UILabel!
    
    @IBOutlet weak var heightConstant: NSLayoutConstraint!
    
    @IBOutlet weak var collapseView: UIView!
    @IBOutlet weak var expandView: UIStackView!
    @IBOutlet weak var expandImageView: UIImageView!
    
    var isExpand: Bool = false
    
    var listExercise: [HMSetsDetailEntity] = [] {
        didSet {
            list.accept(listExercise)
        }
    }
    
    // MARK: - Variables
    private let disposeBag = DisposeBag()
    private let list: BehaviorRelay<[HMSetsDetailEntity]> = BehaviorRelay(value: [])
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTableView()
        collapseView.isHidden = false
        expandView.isHidden = true
    }
    
    func setData(entity: HMExerciseInSessionDetailEntity) {
        listExercise = entity.list_sets ?? []
        heightConstant.constant = CGFloat(46 * (entity.list_sets?.count ?? 0))
        self.titleLabel.text = entity.name
        self.setStatusTaskWithEntity(timeFinish: entity.time_finish)
        self.timeLabel.text = "\(entity.time_finish)s"
        self.dateLabel.text = entity.date
    }

    private func setupTableView() {
        tableView.registerNibCellFor(type: HMDiarySetCell.self)
        
        list.bind(to: tableView.rx.items(cellIdentifier: "HMDiarySetCell", cellType: HMDiarySetCell.self)) { row, model, cell in
            cell.setData(data: model, index: row, type: row == 0 ? .highlight : .normal)
            }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(String.self).subscribe(onNext: {exercise in
            
        }).disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.tableView.deselectRow(at: indexPath, animated: true)
            }).disposed(by: disposeBag)
    }
    
    func updateCollapseUI() {
        isExpand = !isExpand
        if isExpand {
            collapseView.isHidden = true
            expandView.isHidden = false
            expandImageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
        } else {
            collapseView.isHidden = false
            expandView.isHidden = true
            expandImageView.transform = CGAffineTransform(rotationAngle: 0)
        }
    }
    
    func setStatusTaskWithEntity(timeFinish: String) {
        if timeFinish.isEmpty {
            self.statusLabel.text = "Chưa hoàn thành"
            self.statusView.backgroundColor = UIColor.notCompeleteRed
        } else {
            self.statusLabel.text = "Đã hoàn thành"
            self.statusView.backgroundColor = UIColor.appleGreen
        }
    }
    
}
