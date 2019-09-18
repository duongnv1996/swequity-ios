//
//  HMHistoryImageVC.swift
//  SwequityVN
//
//  Created by Tung QT on 8/9/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

class HMHistoryImageVC: HMBaseVC {
    
    // MARK: - Outlets
    @IBOutlet weak var frontCollectionView: UICollectionView!
    @IBOutlet weak var backCollectionView: UICollectionView!
    @IBOutlet weak var sideCollectionView: UICollectionView!
    
    // MARK: - Variables
    var didSelectMenu: ((_ menuType: HMImageType) -> Void)?
    var bodyImages: HMBodyImageEntity? {
        didSet {
            guard let bodyImages = bodyImages else { return }
            frontImages.accept(bodyImages.front)
            sideImages.accept(bodyImages.side)
            backImages.accept(bodyImages.back)
        }
    }
    
    // MARK: - Constant
    private let disposeBag = DisposeBag()
    private let frontImages: BehaviorRelay<[HMBodyImageDetailEntity]> = BehaviorRelay(value: [])
    private let sideImages: BehaviorRelay<[HMBodyImageDetailEntity]> = BehaviorRelay(value: [])
    private let backImages: BehaviorRelay<[HMBodyImageDetailEntity]> = BehaviorRelay(value: [])
    
    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchData()
    }
    
    // MARK: - Setup views
    override func setupView() {
        super.setupView()
        setupFrontCollectionView()
        setupSideCollectionView()
        setupBackCollectionView()
    }
    
    private func setupFrontCollectionView() {
        frontCollectionView.registerNibCellFor(type: HMHistoryImageCell.self)
        
        frontImages
            .bind(to: frontCollectionView.rx.items(cellIdentifier: "HMHistoryImageCell", cellType: HMHistoryImageCell.self)) { row, model, cell in
                cell.setUpData(dto: model)
            }.disposed(by: disposeBag)
        
        frontCollectionView.rx.modelSelected(HMBodyImageDetailEntity.self).subscribe(onNext: { model in
            // TODO : Tap To cell
            HMCompareImageVC.push(prepare: {[weak self] vc in
                vc.rightImg = model.img
                vc.leftImg = self?.frontImages.value[0].img
                vc.rightDate = model.date
                vc.leftDate = self?.frontImages.value[0].date
            })
        }).disposed(by: disposeBag)
        
        frontCollectionView.rx.itemSelected.subscribe(onNext: { indexPath in
            
        }).disposed(by: disposeBag)
        
        frontCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    private func setupSideCollectionView() {
        sideCollectionView.registerNibCellFor(type: HMHistoryImageCell.self)
        
        sideImages
            .bind(to: sideCollectionView.rx.items(cellIdentifier: "HMHistoryImageCell", cellType: HMHistoryImageCell.self)) { row, model, cell in
                cell.setUpData(dto: model)
            }.disposed(by: disposeBag)
        
        sideCollectionView.rx.modelSelected(HMBodyImageDetailEntity.self).subscribe(onNext: {model in
            // TODO : Tap To cell
            HMCompareImageVC.push(prepare: {[weak self] vc in
                vc.rightImg = model.img
                vc.leftImg = self?.sideImages.value[0].img
                vc.rightDate = model.date
                vc.leftDate = self?.sideImages.value[0].date
            })
        }).disposed(by: disposeBag)
        
        sideCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    private func setupBackCollectionView() {
        backCollectionView.registerNibCellFor(type: HMHistoryImageCell.self)
        
        backImages
            .bind(to: backCollectionView.rx.items(cellIdentifier: "HMHistoryImageCell", cellType: HMHistoryImageCell.self)) { row, model, cell in
                cell.setUpData(dto: model)
            }.disposed(by: disposeBag)
        
        backCollectionView.rx.modelSelected(HMBodyImageDetailEntity.self).subscribe(onNext: {model in
            // TODO : Tap To cell
            HMCompareImageVC.push(prepare: {[weak self] vc in
                vc.rightImg = model.img
                vc.leftImg = self?.backImages.value[0].img
                vc.rightDate = model.date
                vc.leftDate = self?.backImages.value[0].date
            })
        }).disposed(by: disposeBag)
        
        backCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
    }

    // MARK: - Management Data
    func reloadData() {
        fetchData()
    }
    
    private func fetchData() {
        HMImageDiaryAPI().execute(target: self, success: {[weak self] (response) in
            guard let sSelf = self else { return }
            switch response.errorId {
            case HMErrorCode.success.rawValue:
                sSelf.bodyImages = response.bodyImages
            case HMErrorCode.error.rawValue:
                UIAlertController.showQuickSystemAlert(message: response.message, cancelButtonTitle: "Đồng ý")
            default:
                break
            }
        }, failure: { (error) in
            UIAlertController.showQuickSystemAlert(message: error.message, cancelButtonTitle: "Đồng ý")
        })
    }
    
    // MARK: - Actions
    
    // MARK: - Private methods
}

extension HMHistoryImageVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 24, left: 18, bottom: 24, right: 18)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 36)
        let height = width + 18
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 24
    }
}
